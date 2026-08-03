resource "aws_security_group" "jenkins" {
  name        = "${var.name}-jenkins-sg"
  description = "Jenkins controller security group"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-jenkins-sg"
    }
  )
}

resource "aws_security_group" "agent" {
  name        = "${var.name}-jenkins-agent-sg"
  description = "Jenkins build agent security group"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-jenkins-agent-sg"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "jenkins" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "agent" {
  security_group_id = aws_security_group.agent.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "agent_ssh_from_jenkins" {
  security_group_id = aws_security_group.agent.id

  referenced_security_group_id = aws_security_group.jenkins.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

