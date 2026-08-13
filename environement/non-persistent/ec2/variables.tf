############################################
# AWS
############################################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


############################################
# Project
############################################

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "poc_name" {
  description = "Person who created the infrastructure"
  type        = string
}

variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

############################################
# EC2
############################################

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}


############################################
# IAM
############################################

variable "iam_instance_profile" {
  description = "IAM instance profile attached to EC2"
  type        = string
  default     = null
}


############################################
# Storage
############################################

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 50
}
variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}


############################################
# Security
############################################

variable "http_ingress_cidr" {
  description = "CIDR allowed to access HTTP"
  type        = string
  default     = "0.0.0.0/0"
}


############################################
# Tags
############################################

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "additional_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "user_data_replace_on_change" {
  description = "Whether to replace user data on change"
  type        = bool
  default     = true
}