############################################
# General
############################################

variable "name" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to every resource"
  type        = map(string)

  default = {}
}

############################################
# Networking
############################################

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "jenkins_subnet_id" {
  description = "Public subnet for Jenkins controller"
  type        = string
}

variable "agent_subnet_id" {
  description = "Private subnet for Jenkins agent"
  type        = string
}

############################################
# Route53
############################################

variable "private_zone_id" {
  description = "Private Route53 Hosted Zone ID"
  type        = string
}

variable "private_zone_name" {
  description = "Private Hosted Zone Name"
  type        = string
}

############################################
# EC2
############################################

variable "ami_id" {
  description = "AMI ID"

  type = string
}

variable "jenkins_instance_type" {

  description = "Jenkins controller instance type"

  type = string

  default = "t3.medium"
}

variable "agent_instance_type" {

  description = "Jenkins build agent instance type"

  type = string

  default = "t3.large"
}

############################################
# Storage
############################################

variable "jenkins_volume_size" {

  description = "Root volume size for Jenkins"

  type = number

  default = 50
}

variable "agent_volume_size" {

  description = "Root volume size for Jenkins Agent"

  type = number

  default = 80
}