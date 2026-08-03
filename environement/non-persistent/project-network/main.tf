module "project_network" {
  source = "../../../modules/project-network"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = var.vpc_id

  database_security_group_id = var.database_security_group_id
  database_private_ip        = var.database_private_ip

  database_port = var.database_port

  application_private_ip = var.application_private_ip

  private_zone_name = var.private_zone_name
  database_dns_name = var.database_dns_name

  http_ingress_cidr = var.http_ingress_cidr
  enable_https      = var.enable_https

  common_tags = var.common_tags
}