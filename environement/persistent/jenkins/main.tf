module "jenkins" {

  source = "../modules/jenkins"

  name = "${var.project_name}-${var.environment}"

  ami_id = var.ami_id

  vpc_id = module.vpc.vpc_id

  jenkins_subnet_id = module.vpc.private_subnet_ids[0]

  agent_subnet_id = module.vpc.private_subnet_ids[1]

  jenkins_instance_type = var.controller_instance_type

  agent_instance_type = var.agent_instance_type

  jenkins_volume_size = var.controller_volume_size

  agent_volume_size = var.agent_volume_size

  private_zone_id = var.private_zone_id

  private_zone_name = var.private_zone_name

  common_tags = var.common_tags

  depends_on = [
    module.vpc
  ]
}