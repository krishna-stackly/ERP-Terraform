module "project_network" {
  source = "git::https://github.com/krishna-stackly/ERP-Terraform.git//modules/project-network?ref=main"
  # once you cut a release tag, switch to: ?ref=project-network-v1.0.0

  ############################################
  # General
  ############################################
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags

  ############################################
  # VPC
  ############################################
  vpc_id = local.vpc_id

  ############################################
  # Database DNS
  ############################################
  database_private_ip = local.db_private_ip
  database_dns_name    = var.database_dns_name

  ############################################
  # Application DNS
  ############################################
  application_private_ip = local.app_private_ip
  application_dns_name   = var.application_dns_name

  ############################################
  # Route53
  ############################################
  private_zone_name = var.private_zone_name
}