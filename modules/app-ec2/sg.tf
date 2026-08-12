############################################
# Application Security Group
############################################

resource "aws_security_group" "app" {
  name        = "${var.name}-sg"
  description = "Application security group for ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    var.additional_tags,
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

