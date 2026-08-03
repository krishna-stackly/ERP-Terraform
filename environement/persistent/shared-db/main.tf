###############DATABASE###############################
module "database" {
  source = "../modules/database"

  name = "${var.project_name}-${var.environment}-shared-db"

  ami_id        = var.ami_id
  instance_type = var.db_instance_type

  vpc_id = module.vpc.vpc_id

  subnet_id = module.vpc.private_subnet_ids[1]

  root_volume_size = var.db_root_volume_size
  data_volume_size = var.db_data_volume_size

  allowed_security_group_ids = [
    aws_security_group.app.id
  ]

  common_tags = merge(
    var.common_tags,
    {
      Role      = "Database"
      Lifecycle = "Persistent"
    }
  )
}