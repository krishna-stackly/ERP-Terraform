############################################
# VPC ID from SSM
############################################

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/network/vpc_id"
}


############################################
# Private Subnets from SSM
############################################

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/network/private_subnet_ids"
}


############################################
# App Security Group ID from SSM
############################################

# data "aws_ssm_parameter" "app_security_group_id" {
#   name = "/${var.project_name}/${var.environment}/app/sg-id"
# }

data "aws_ssm_parameter" "db_security_group" {
  name = "/${var.project_name}/${var.environment}/database/sg-id"
}

############################################
# Locals
############################################

locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  private_subnet_ids = split(
    ",",
    data.aws_ssm_parameter.private_subnet_ids.value
  )
  db_security_group_id = data.aws_ssm_parameter.db_security_group.value
  # app_security_group_id = data.aws_ssm_parameter.app_security_group_id.value
}