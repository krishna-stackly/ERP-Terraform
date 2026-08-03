############################################
# General
############################################

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}


############################################
# VPC
############################################

variable "vpc_id" {
  description = "Existing shared VPC ID"
  type        = string
}


############################################
# Database
############################################

variable "database_security_group_id" {
  description = "Security group ID of persistent shared DB"
  type        = string
}

variable "database_private_ip" {
  description = "Private IP of persistent shared DB EC2"
  type        = string
}

variable "database_port" {
  description = "Database port"
  type        = number
  default     = 3306
}


############################################
# Application
############################################

variable "application_private_ip" {
  description = "Private IP of application EC2"
  type        = string
}


############################################
# Route53
############################################

variable "private_zone_name" {
  description = "Private hosted zone name"
  type        = string
  default     = "internal"
}

variable "database_dns_name" {
  description = "Internal database hostname"
  type        = string
  default     = "mysql-db.internal"
}

variable "application_dns_name" {
  description = "Internal application hostname"
  type        = string
  default     = "app.internal"
}


############################################
# Ingress
############################################

variable "http_ingress_cidr" {
  description = "CIDR allowed to access application HTTP/HTTPS"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_https" {
  description = "Enable HTTPS ingress"
  type        = bool
  default     = false
}