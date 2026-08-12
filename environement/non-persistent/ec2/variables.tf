############################################
# AWS
############################################

variable "aws_region" {

  description = "AWS region"

  type = string

  default = "us-east-1"
}


############################################
# Project
############################################

variable "project_name" {

  description = "Project name"

  type = string
}

variable "environment" {

  description = "Environment"

  type = string
}

variable "poc_name" {

  description = "Person who created the infrastructure"

  type = string
}


############################################
# EC2
############################################

variable "ami_id" {

  description = "AMI ID"

  type = string
}

variable "instance_type" {

  description = "EC2 instance type"

  type = string

  default = "t3.large"
}


############################################
# Networking
############################################

variable "vpc_id" {

  description = "VPC ID"

  type = string
}

variable "subnet_id" {

  description = "Subnet ID for application EC2"

  type = string
}


############################################
# IAM
############################################

variable "iam_instance_profile" {

  description = "IAM instance profile"

  type = string

  default = null
}


############################################
# Storage
############################################

variable "root_volume_size" {

  description = "Root volume size in GB"

  type = number

  default = 50
}


############################################
# Security
############################################

variable "http_ingress_cidr" {

  description = "CIDR allowed to access application"

  type = string

  default = "0.0.0.0/0"
}


############################################
# Tags
############################################

variable "common_tags" {

  description = "Common tags"

  type = map(string)

  default = {}
}