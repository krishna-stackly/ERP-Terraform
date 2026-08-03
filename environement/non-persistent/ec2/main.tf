############################################
# Application SG
############################################

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Application EC2 security group"

  vpc_id = module.vpc.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-sg"
    }
  )
}


############################################
# HTTP
############################################

resource "aws_vpc_security_group_ingress_rule" "app_http" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


############################################
# Outbound
############################################

resource "aws_vpc_security_group_egress_rule" "app" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


############################################
# App EC2
############################################

module "app_ec2" {
  source = "../modules/ec2"

  name = "${var.project_name}-${var.environment}-app"

  ami_id        = var.ami_id
  instance_type = var.app_instance_type

  subnet_id = module.vpc.public_subnet_ids[0]

  security_group_ids = [
    aws_security_group.app.id
  ]

  associate_public_ip_address = true

  root_volume_size = var.app_volume_size

  user_data = file("${path.module}/scripts/app.sh")

  common_tags = var.common_tags

  additional_tags = {
    Project     = var.project_name
    Environment = var.environment
    Role        = "Application"
    Lifecycle   = "Ephemeral"
  }
}