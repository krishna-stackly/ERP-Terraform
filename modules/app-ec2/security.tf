############################################
# Application Security Group
############################################

resource "aws_security_group" "app" {

  count = var.create_security_group ? 1 : 0

  name = "${var.name}-sg"

  description = "Application security group for ${var.name}"

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.name}-sg"
      Project     = var.project_name
      Environment = var.environment
      State       = "non-persistent"
      Created_by  = var.poc_name
      Component   = "Application"
    }
  )
}


############################################
# HTTP
############################################

resource "aws_vpc_security_group_ingress_rule" "http" {

  count = var.create_security_group && var.enable_http ? 1 : 0

  security_group_id = aws_security_group.app[0].id

  cidr_ipv4 = var.http_ingress_cidr

  from_port = 80
  to_port   = 80

  ip_protocol = "tcp"
}


############################################
# HTTPS
############################################

resource "aws_vpc_security_group_ingress_rule" "https" {

  count = var.create_security_group && var.enable_https ? 1 : 0

  security_group_id = aws_security_group.app[0].id

  cidr_ipv4 = var.http_ingress_cidr

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"
}


############################################
# Outbound
############################################

resource "aws_vpc_security_group_egress_rule" "all" {

  count = var.create_security_group ? 1 : 0

  security_group_id = aws_security_group.app[0].id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"
}