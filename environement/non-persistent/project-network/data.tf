############################################
# VPC ID from SSM
############################################

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/network/vpc_id"
}


############################################
# App Private IP from SSM
# (published by app-ec2 - see ssm.tf addition above)
############################################

data "aws_ssm_parameter" "app_private_ip" {
  name = "/${var.project_name}/${var.environment}/app/private-ip"
}


############################################
# DB Private IP from SSM
# (published by Shared-db)
############################################

data "aws_ssm_parameter" "db_private_ip" {
  name = "/${var.project_name}/${var.environment}/db/private-ip"
}


############################################
# Locals
############################################

locals {
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  app_private_ip  = data.aws_ssm_parameter.app_private_ip.value
  db_private_ip   = data.aws_ssm_parameter.db_private_ip.value
}

data "aws_ssm_parameter" "app_private_ip" {
  name = "/${var.project_name}/${var.environment}/app/private-ip"
}

