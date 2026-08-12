############################################
# AWS
############################################

variable "aws_region" {
  type = string
}

############################################
# Project
############################################

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

############################################
# EC2
############################################

variable "ami_id" {
  type = string
}

variable "controller_instance_type" {

  type = string

  default = "t3.medium"
}

variable "agent_instance_type" {

  type = string

  default = "t3.large"
}

############################################
# Storage
############################################

variable "controller_volume_size" {

  type = number

  default = 50
}

variable "agent_volume_size" {

  type = number

  default = 80
}

############################################
# Route53
############################################

variable "private_zone_id" {
  type = string
}

variable "private_zone_name" {
  type = string
}

############################################
# Tags
############################################

variable "common_tags" {

  type = map(string)

  default = {}

}