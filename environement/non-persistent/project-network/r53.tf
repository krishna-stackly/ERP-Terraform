resource "aws_route53_record" "app" {
  zone_id = module.project_network.private_zone_id

  name = var.application_dns_name
  type = "A"
  ttl  = 60

  records = [
    module.app.private_ip
  ]
}