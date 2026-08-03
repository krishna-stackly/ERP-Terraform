variable "name" {
  description = "Database EC2 name"
  type        = string
}

variable "ami_id" {
  description = "Database EC2 AMI"
  type        = string
}

variable "instance_type" {
  description = "Database instance type"
  type        = string
  default     = "t3.large"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet for database"
  type        = string
}

variable "root_volume_size" {
  description = "OS/root EBS size"
  type        = number
  default     = 30
}

variable "data_volume_size" {
  description = "Persistent database data volume size"
  type        = number
  default     = 100
}

variable "data_device_name" {
  description = "EBS device name"
  type        = string
  default     = "/dev/sdf"
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to MySQL"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  type    = map(string)
  default = {}
}