############################################
# Application Security Group ID -> SSM
############################################

resource "aws_ssm_parameter" "app_security_group_id" {
  name        = "/${var.project_name}/${var.environment}/app/sg-id"
  description = "Application security group ID for ${var.project_name}-${var.environment}"

  type  = "String"
  value = aws_security_group.app.id

  tags = merge(
    var.common_tags,
    var.additional_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      State       = "non-persistent"
      Created_by  = var.poc_name
      Component   = "Application"
    }
  )
}