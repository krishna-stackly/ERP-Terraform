variable "name" {
  description = "EC2 instance name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to EC2"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate public IPv4 address"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "user_data" {
  description = "EC2 bootstrap script"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Replace instance when user_data changes"
  type        = bool
  default     = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}