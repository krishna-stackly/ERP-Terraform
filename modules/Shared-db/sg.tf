resource "aws_ssm_parameter" "db_security_group_id" {
  name        = "/${var.project_name}/${var.environment}/db/sg-id"
  description = "Shared database security group ID for ${var.project_name}-${var.environment}"

  type  = "String"
  value = aws_security_group.database.id

  tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      Created_by  = var.poc_name
    }
  )
}