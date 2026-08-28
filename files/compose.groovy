def call(Map config) {

    pipeline {

        agent {
            node {
                label '007'
            }
        }

        parameters {

            choice(
                name: 'ENVIRONMENT',
                choices: config.environments.keySet().toList(),
                description: 'Target environment'
            )

            string(
                name: 'VERSION',
                defaultValue: 'latest',
                description: 'Docker image version/tag'
            )
        }

        environment {

            APP_VERSION = "${params.VERSION}"
            TARGET_ENV  = "${params.ENVIRONMENT}"

            ACCOUNT_ID  = "${config.accountId}"
            AWS_REGION  = "${config.awsRegion}"

            /*
             * Terraform-aligned tag values
             */
            PROJECT  = "${config.projectName}"
            POC_NAME = "${config.pocName}"
            component = "${config.componentName}"

            /*
             * Resource names from Terraform
             */
            APP_NAME       = "${config.appName}"
            SHARED_DB_NAME = "${config.sharedDbName}"

            /*
             * Docker Hub
             */
            DOCKER_REPO = "${config.dockerHubRepo}"

            /*
             * Jenkins credential IDs
             */
            GITHUB_CREDENTIALS = "${config.githubCredentials ?: 'github-erp'}"
            DOCKER_CREDENTIALS = "${config.dockerCredentials ?: 'dockerhub-erp'}"
            AWS_CREDENTIALS    = "${config.awsCredentials ?: 'aws-erp'}"
        }

        options {
            disableConcurrentBuilds()
            timestamps()
        }

        stages {

            /*
             * ============================================================
             * STAGE 1
             * DISCOVER AWS INFRASTRUCTURE
             *
             * App filters:
             *   Project
             *   Environment
             *   Created_by
             *   Name
             *
             * Database filters:
             *   Project
             *   Environment
             *   Created_by
             *   Name
             *   component = database
             *   Lifecycle = Persistent
             * ============================================================
             */

            stage('Discover Infrastructure') {

                steps {

                    script {

                        withCredentials([
                            [
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "${AWS_CREDENTIALS}"
                            ]
                        ]) {

                            sh """
                                set -e

                                echo "=========================================="
                                echo "VERIFYING AWS ACCESS"
                                echo "=========================================="

                                aws sts get-caller-identity

                                echo ""
                                echo "AWS Region  : ${AWS_REGION}"
                                echo "Project     : ${PROJECT}"
                                echo "Environment : ${TARGET_ENV}"
                                echo "Created By  : ${POC_NAME}"
                            """


                            /*
                             * =================================================
                             * DISCOVER APPLICATION EC2 PUBLIC IP
                             * =================================================
                             */

                            def appPublicIp = sh(
                                script: """
                                    set -e

                                    aws ec2 describe-instances \
                                        --region "${AWS_REGION}" \
                                        --filters \
                                            "Name=tag:Project,Values=${PROJECT}" \
                                            "Name=tag:Environment,Values=${TARGET_ENV}" \
                                            "Name=tag:Created_by,Values=${POC_NAME}" \
                                            "Name=tag:component,Values=${component}" \
                                            "Name=instance-state-name,Values=running" \
                                        --query 'Reservations[].Instances[].PublicIpAddress' \
                                        --output text
                                """,
                                returnStdout: true
                            ).trim()


                            if (!appPublicIp ||
                                appPublicIp == 'None') {

                                error("""
                                    Application EC2 was not found.

                                    Expected tags:

                                    Project     = ${PROJECT}
                                    Environment = ${TARGET_ENV}
                                    Created_by  = ${POC_NAME}
                                    Name        = ${APP_NAME}
                                """)
                            }


                            /*
                             * =================================================
                             * DISCOVER SHARED DATABASE IP
                             *
                             * Terraform tags:
                             *
                             * Name        = var.name
                             * Role        = Database
                             * Lifecycle   = Persistent
                             * Project     = var.project_name
                             * Environment = var.environment
                             * Created_by  = var.poc_name
                             * component   = database
                             * =================================================
                             */

                            def sharedDbIp = sh(
                                script: """
                                    set -e

                                    aws ec2 describe-instances \
                                        --region "${AWS_REGION}" \
                                        --filters \
                                            "Name=tag:Project,Values=${PROJECT}" \
                                            "Name=tag:Environment,Values=${TARGET_ENV}" \
                                            "Name=tag:Created_by,Values=${POC_NAME}" \
                                            "Name=tag:Name,Values=${SHARED_DB_NAME}" \
                                            "Name=tag:Role,Values=Database" \
                                            "Name=tag:Lifecycle,Values=Persistent" \
                                            "Name=tag:component,Values=database" \
                                            "Name=instance-state-name,Values=running" \
                                        --query 'Reservations[].Instances[].PublicIpAddress' \
                                        --output text
                                """,
                                returnStdout: true
                            ).trim()


                            if (!sharedDbIp ||
                                sharedDbIp == 'None') {

                                error("""
                                    Shared Database EC2 was not found.

                                    Expected tags:

                                    Project     = ${PROJECT}
                                    Environment = ${TARGET_ENV}
                                    Created_by  = ${POC_NAME}
                                    Name        = ${SHARED_DB_NAME}
                                    Role        = Database
                                    Lifecycle   = Persistent
                                    component   = database
                                """)
                            }


                            /*
                             * =================================================
                             * STORE DISCOVERED VALUES
                             *
                             * These remain available in all later stages.
                             * =================================================
                             */

                            env.APP_PUBLIC_IP = appPublicIp
                            env.SHARED_DB_IP  = sharedDbIp


                            echo """
                            ==========================================
                            INFRASTRUCTURE DISCOVERED SUCCESSFULLY
                            ==========================================

                            APP PUBLIC IP : ${env.APP_PUBLIC_IP}

                            SHARED DB IP  : ${env.SHARED_DB_IP}

                            ==========================================
                            """
                        }
                    }
                }
            }


            /*
             * ============================================================
             * STAGE 2
             * CHECKOUT PRIVATE GITHUB REPOSITORY
             * ============================================================
             */

            stage('Checkout Source Code') {

                steps {

                    cleanWs()

                    checkout([

                        $class: 'GitSCM',

                        branches: [[
                            name: "${config.gitBranch ?: '*/main'}"
                        ]],

                        userRemoteConfigs: [[
                            url: config.gitRepo,
                            credentialsId: "${GITHUB_CREDENTIALS}"
                        ]]
                    ])

                    script {

                        env.GIT_COMMIT_SHORT = sh(
                            script: 'git rev-parse --short HEAD',
                            returnStdout: true
                        ).trim()

                        echo """
                        ==========================================
                        SOURCE CODE CHECKED OUT
                        ==========================================

                        Repository : ${config.gitRepo}
                        Branch     : ${config.gitBranch ?: 'main'}
                        Commit     : ${env.GIT_COMMIT_SHORT}

                        ==========================================
                        """
                    }
                }
            }


            /*
             * ============================================================
             * STAGE 3
             * GENERATE .env FILE
             *
             * .env.template is committed to Git.
             * Actual .env is generated by Jenkins.
             * ============================================================
             */

            stage('Generate Environment File') {

                steps {

                    sh """
                        set -e

                        echo "=========================================="
                        echo "GENERATING .env FILE"
                        echo "=========================================="

                        if [ ! -f ".env.template" ]; then
                            echo "ERROR: .env.template not found"
                            exit 1
                        fi

                        cp .env.template .env

                        /*
                         * Replace frontend/application public IP.
                         */

                        sed -i \
                            "s|__FRONTEND_IP__|${APP_PUBLIC_IP}|g" \
                            .env

                        /*
                         * Replace database host.
                         */

                        sed -i \
                            "s|__DB_HOST__|${SHARED_DB_IP}|g" \
                            .env

                        echo ".env generated successfully"
                    """

                    sh """
                        echo "=========================================="
                        echo "VALIDATING GENERATED VALUES"
                        echo "=========================================="

                        grep '^ALLOWED_HOSTS=' .env || true
                        grep '^CORS_ALLOWED_ORIGINS=' .env || true
                        grep '^FRONTEND_URL=' .env || true
                        grep '^DB_HOST=' .env || true

                        echo "=========================================="
                    """
                }
            }


            /*
             * ============================================================
             * STAGE 4
             * DOCKER LOGIN
             * ============================================================
             */

            stage('Docker Login') {

                steps {

                    withCredentials([

                        usernamePassword(

                            credentialsId: "${DOCKER_CREDENTIALS}",

                            usernameVariable: 'DOCKER_USERNAME',

                            passwordVariable: 'DOCKER_PASSWORD'
                        )
                    ]) {

                        sh """
                            set -e

                            echo "Logging in to Docker Hub"

                            echo "\$DOCKER_PASSWORD" | docker login \
                                --username "\$DOCKER_USERNAME" \
                                --password-stdin
                        """
                    }
                }
            }


            /*
             * ============================================================
             * STAGE 5
             * BUILD DOCKER IMAGE
             *
             * Two tags are created:
             *
             * repository:VERSION
             * repository:GIT_COMMIT
             * ============================================================
             */

            stage('Build Docker Image') {

                steps {

                    sh """
                        set -e

                        echo "=========================================="
                        echo "BUILDING DOCKER IMAGE"
                        echo "=========================================="

                        echo "Repository : ${DOCKER_REPO}"
                        echo "Version    : ${APP_VERSION}"
                        echo "Git Commit : ${GIT_COMMIT_SHORT}"

                        docker build \
                            -t ${DOCKER_REPO}:${APP_VERSION} \
                            -t ${DOCKER_REPO}:${GIT_COMMIT_SHORT} \
                            .
                    """
                }
            }


            /*
             * ============================================================
             * STAGE 6
             * PUSH DOCKER IMAGE
             * ============================================================
             */

            stage('Push Docker Image') {

                steps {

                    sh """
                        set -e

                        echo "=========================================="
                        echo "PUSHING DOCKER IMAGE"
                        echo "=========================================="

                        echo "Pushing:"
                        echo "${DOCKER_REPO}:${APP_VERSION}"

                        docker push \
                            ${DOCKER_REPO}:${APP_VERSION}


                        echo ""
                        echo "Pushing immutable image:"
                        echo "${DOCKER_REPO}:${GIT_COMMIT_SHORT}"

                        docker push \
                            ${DOCKER_REPO}:${GIT_COMMIT_SHORT}


                        echo "=========================================="
                        echo "DOCKER PUSH COMPLETED"
                        echo "=========================================="
                    """
                }
            }
        }


        /*
         * ============================================================
         * POST ACTIONS
         * ============================================================
         */

        post {

            success {

                echo """
                ==============================================
                PIPELINE COMPLETED SUCCESSFULLY
                ==============================================

                ENVIRONMENT : ${TARGET_ENV}

                AWS ACCOUNT : ${ACCOUNT_ID}
                AWS REGION  : ${AWS_REGION}

                PROJECT     : ${PROJECT}

                APP IP      : ${APP_PUBLIC_IP}
                SHARED DB   : ${SHARED_DB_IP}

                VERSION     : ${APP_VERSION}
                GIT COMMIT  : ${GIT_COMMIT_SHORT}

                DOCKER IMAGES:

                ${DOCKER_REPO}:${APP_VERSION}

                ${DOCKER_REPO}:${GIT_COMMIT_SHORT}

                ==============================================
                """
            }


            failure {

                echo """
                ==============================================
                PIPELINE FAILED
                ==============================================

                Environment : ${TARGET_ENV}

                Check the Jenkins stage logs.

                ==============================================
                """
            }


            always {

                sh '''
                    docker logout || true
                '''

                cleanWs()
            }
        }
    }
}




