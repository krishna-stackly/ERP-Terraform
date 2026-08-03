resource "aws_route53_record" "jenkins" {
  zone_id = var.private_zone_id

  name = "jenkins.${var.private_zone_name}"
  type = "A"
  ttl  = 60

  records = [
    aws_instance.jenkins.private_ip
  ]
}


resource "aws_route53_record" "agent" {
  zone_id = var.private_zone_id

  name = "jenkins-agent.${var.private_zone_name}"
  type = "A"
  ttl  = 60

  records = [
    aws_instance.agent.private_ip
  ]
}

