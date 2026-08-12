module "app_ec2" {

  source = "git::https://github.com/krishna-stackly/ERP-Terraform.git//modules/ec2?ref=main"

  ############################################
  # Identity
  ############################################

  name = "${var.project_name}-${var.environment}-app"

  project_name = var.project_name
  environment  = var.environment
  poc_name     = var.poc_name


  ############################################
  # EC2
  ############################################

  ami_id        = var.ami_id
  instance_type = var.instance_type


  ############################################
  # Network - dynamically discovered
  ############################################

  vpc_id = local.vpc_id

  subnet_id = local.public_subnet_ids[0]


  ############################################
  # Public IP
  ############################################

  associate_public_ip_address = true


  ############################################
  # IAM
  ############################################

  iam_instance_profile = var.iam_instance_profile


  ############################################
  # Storage
  ############################################

  root_volume_size = var.root_volume_size
  root_volume_type = "gp3"


  ############################################
  # Security
  ############################################

  create_security_group = true

  http_ingress_cidr = var.http_ingress_cidr

  enable_http = true

  enable_https = false


  ############################################
  # Bootstrap
  ############################################

  user_data = file("${path.module}/scripts/app.sh")

  user_data_replace_on_change = true


  ############################################
  # Tags
  ############################################

  common_tags = var.common_tags

  additional_tags = {
    Role      = "Application"
    Lifecycle = "Ephemeral"
  }
}