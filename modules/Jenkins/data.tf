data "aws_ssm_parameter" "vpc_id" {
  name = "/devops-platform/dev/network/vpc_id"
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/devops-platform/dev/network/private_subnet_ids"
}

locals {
  private_subnets = split(
    ",",
    data.aws_ssm_parameter.private_subnets.value
  )
}