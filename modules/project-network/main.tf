############################################
# Application Security Group
############################################

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Security group for project application EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-app-sg"
      Project     = var.project_name
      Environment = var.environment
      Lifecycle   = "Ephemeral"
    }
  )
}


############################################
# Internet -> Frontend
############################################

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4 = var.http_ingress_cidr

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


############################################
# HTTPS
############################################

resource "aws_vpc_security_group_ingress_rule" "https" {
  count = var.enable_https ? 1 : 0

  security_group_id = aws_security_group.app.id

  cidr_ipv4 = var.http_ingress_cidr

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


############################################
# Application Outbound
############################################

resource "aws_vpc_security_group_egress_rule" "app" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


############################################
# App -> Persistent DB
############################################

resource "aws_vpc_security_group_ingress_rule" "database_from_app" {
  security_group_id = var.database_security_group_id

  referenced_security_group_id = aws_security_group.app.id

  from_port   = var.database_port
  to_port     = var.database_port
  ip_protocol = "tcp"
}


############################################
# Route53 Private Hosted Zone
############################################

resource "aws_route53_zone" "internal" {
  name = var.private_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    var.common_tags,
    {
      Name        = var.private_zone_name
      Project     = var.project_name
      Environment = var.environment
      Lifecycle   = "Ephemeral"
    }
  )
}


############################################
# DB DNS
#
# mysql-db.internal -> DB private IP
############################################

resource "aws_route53_record" "database" {
  zone_id = aws_route53_zone.internal.zone_id

  name = var.database_dns_name
  type = "A"
  ttl  = 60

  records = [
    var.database_private_ip
  ]
}


############################################
# Application DNS
#
# app.internal -> App private IP
############################################

resource "aws_route53_record" "application" {
  zone_id = aws_route53_zone.internal.zone_id

  name = var.application_dns_name
  type = "A"
  ttl  = 60

  records = [
    var.application_private_ip
  ]
}