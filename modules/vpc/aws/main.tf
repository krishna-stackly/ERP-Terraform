module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = var.vpc_cidr

  azs = var.availability_zones

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
  # VPC Flow Logs
  ############################################

  enable_flow_log = var.enable_flow_log

  ############################################
  # Subnet Tags
  ############################################

  public_subnet_tags = merge(
    var.public_subnet_tags,
    {
      "kubernetes.io/role/elb" = "1"
    }
  )

  private_subnet_tags = merge(
    var.private_subnet_tags,
    {
      "kubernetes.io/role/internal-elb" = "1"
    }
  )

  ############################################
  # Common Tags
  ############################################

  tags = local.common_tags
}


############################################
# SSM - VPC ID
############################################

resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/network/vpc_id"

  description = "VPC ID for ${local.name}"

  type  = "String"
  value = module.vpc.vpc_id

  tags = local.common_tags
}


############################################
# SSM - Public Subnet IDs
############################################

resource "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/network/public_subnet_ids"

  description = "Public subnet IDs for ${local.name}"

  type  = "StringList"
  value = join(",", module.vpc.public_subnets)

  tags = local.common_tags
}


############################################
# SSM - Private Subnet IDs
############################################

resource "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/network/private_subnet_ids"

  description = "Private subnet IDs for ${local.name}"

  type  = "StringList"
  value = join(",", module.vpc.private_subnets)

  tags = local.common_tags
}


############################################
# SSM - VPC CIDR Block
############################################

resource "aws_ssm_parameter" "vpc_cidr_block" {
  name = "/${var.project_name}/${var.environment}/network/vpc_cidr_block"

  description = "VPC CIDR block for ${local.name}"

  type  = "String"
  value = module.vpc.vpc_cidr_block

  tags = local.common_tags
}


############################################
# SSM - NAT Gateway IDs
############################################

resource "aws_ssm_parameter" "nat_gateway_ids" {
  count = length(module.vpc.natgw_ids) > 0 ? 1 : 0

  name = "/${var.project_name}/${var.environment}/network/nat_gateway_ids"

  description = "NAT Gateway IDs for ${local.name}"

  type  = "StringList"
  value = join(",", module.vpc.natgw_ids)

  tags = local.common_tags
}


############################################
# SSM - Public Route Table IDs
############################################

resource "aws_ssm_parameter" "public_route_table_ids" {
  count = length(module.vpc.public_route_table_ids) > 0 ? 1 : 0

  name = "/${var.project_name}/${var.environment}/network/public_route_table_ids"

  description = "Public route table IDs for ${local.name}"

  type  = "StringList"
  value = join(",", module.vpc.public_route_table_ids)

  tags = local.common_tags
}


############################################
# SSM - Private Route Table IDs
############################################

resource "aws_ssm_parameter" "private_route_table_ids" {
  count = length(module.vpc.private_route_table_ids) > 0 ? 1 : 0

  name = "/${var.project_name}/${var.environment}/network/private_route_table_ids"

  description = "Private route table IDs for ${local.name}"

  type  = "StringList"
  value = join(",", module.vpc.private_route_table_ids)

  tags = local.common_tags
}


############################################
# SSM - Availability Zones
############################################

resource "aws_ssm_parameter" "availability_zones" {
  name = "/${var.project_name}/${var.environment}/network/availability_zones"

  description = "Availability zones used by ${local.name}"

  type  = "StringList"
  value = join(",", var.availability_zones)

  tags = local.common_tags
}