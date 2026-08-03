module "app" {
  source = "../../../modules/ec2"

  name = "${var.project_name}-${var.environment}-app"

  ami_id        = var.ami_id
  instance_type = var.app_instance_type

  subnet_id = var.app_subnet_id

  security_group_ids = [
    module.project_network.app_security_group_id
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

