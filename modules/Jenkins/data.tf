data "aws_ssm_parameter" "vpc_id" {
  name = "/devops-platform/dev/network/vpc_id"
}

data "aws_ssm_parameter" "public_subnets" {
  name = "/devops-platform/dev/network/public_subnet_ids"
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/devops-platform/dev/network/private_subnet_ids"
}

locals {

  public_subnets = split(
    ",",
    data.aws_ssm_parameter.public_subnets.value
  )

  private_subnets = split(
    ",",
    data.aws_ssm_parameter.private_subnets.value
  )
}