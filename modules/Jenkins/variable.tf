variable "name" {
  description = "Naming prefix"
  type        = string
}

variable "ami_id" {
  description = "AMI used by Jenkins controller and agent"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "jenkins_subnet_id" {
  description = "Private subnet for Jenkins controller"
  type        = string
}

variable "agent_subnet_id" {
  description = "Private subnet for Jenkins build agent"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Jenkins controller instance type"
  type        = string
  default     = "t3.medium"
}

variable "agent_instance_type" {
  description = "Jenkins agent instance type"
  type        = string
  default     = "t3.large"
}

variable "jenkins_volume_size" {
  description = "Jenkins controller root volume size"
  type        = number
  default     = 50
}

variable "agent_volume_size" {
  description = "Jenkins agent root volume size"
  type        = number
  default     = 80
}

variable "private_zone_id" {
  description = "Route53 private hosted zone ID"
  type        = string
}

variable "private_zone_name" {
  description = "Route53 private hosted zone name"
  type        = string
  default     = "internal"
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}