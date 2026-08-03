############################################
# General
############################################

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}


############################################
# Existing VPC
############################################

variable "vpc_id" {
  type = string
}

variable "app_subnet_id" {
  type = string
}


############################################
# Existing Shared DB
############################################

variable "database_security_group_id" {
  type = string
}

variable "database_private_ip" {
  type = string
}

variable "database_port" {
  type    = number
  default = 3306
}


############################################
# App
############################################

variable "ami_id" {
  type = string
}

variable "app_instance_type" {
  type    = string
  default = "t3.large"
}

variable "app_volume_size" {
  type    = number
  default = 50
}

variable "application_private_ip" {
  type = string
}


############################################
# DNS
############################################

variable "private_zone_name" {
  type    = string
  default = "internal"
}

variable "database_dns_name" {
  type    = string
  default = "mysql-db.internal"
}

variable "application_dns_name" {
  type    = string
  default = "app.internal"
}


############################################
# HTTP
############################################

variable "http_ingress_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "enable_https" {
  type    = bool
  default = false
}