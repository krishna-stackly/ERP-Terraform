module "vpc" {
  source = "../../modules/vpc"

  ############################################
  # Project
  ############################################

  project_name = var.project_name
  environment  = var.environment


  ############################################
  # VPC
  ############################################

  vpc_cidr = var.vpc_cidr


  ############################################
  # Availability Zones
  ############################################

  availability_zones = var.availability_zones


  ############################################
  # Subnets
  ############################################

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets


  ############################################
  # NAT Gateway
  ############################################

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway


  ############################################
  # DNS
  ############################################

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames


  ############################################
  # Flow Logs
  ############################################

  enable_flow_log = var.enable_flow_log


  ############################################
  # Subnet Tags
  ############################################

  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags


  ############################################
  # Common Tags
  ############################################

  common_tags = var.common_tags
}




############################################
# Jenkins
############################################

module "jenkins" {
  source = "../modules/jenkins"

  name   = "${var.project_name}-${var.environment}"
  ami_id = var.ami_id

  vpc_id = module.vpc.vpc_id

  # Jenkins controller in private subnet AZ-A
  controller_subnet_id = module.vpc.private_subnet_ids[0]

  # Jenkins agent in private subnet AZ-B
  agent_subnet_id = module.vpc.private_subnet_ids[1]

  controller_instance_type = var.controller_instance_type
  agent_instance_type      = var.agent_instance_type

  controller_volume_size = var.controller_volume_size
  agent_volume_size      = var.agent_volume_size

  common_tags = var.common_tags

  depends_on = [
    module.vpc
  ]
}





