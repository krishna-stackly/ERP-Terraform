resource "aws_security_group" "database" {
  name        = "${var.name}-sg"
  description = "Shared database security group"

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-sg"
    }
  )
}


############################################
# MySQL access
############################################

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  for_each = toset(var.allowed_security_group_ids)

  security_group_id = aws_security_group.database.id

  referenced_security_group_id = each.value

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}


############################################
# Outbound
############################################

resource "aws_vpc_security_group_egress_rule" "database" {
  security_group_id = aws_security_group.database.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}