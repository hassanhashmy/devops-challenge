################################################################################
# General settings
################################################################################

variable "name" {
  description = "The prefix or project name which will be included in the name of most resources."
  type        = string
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC settings
################################################################################

variable "vpc_id" {
  description = "Specifies the id of an existing VPC"
  type        = string
}

variable "subnet_id" {
  description = "Specifies the subnet id to place EC2 instance"
  type        = string
}

################################################################################
# EC2 settings
################################################################################

variable "instance_type" {
  description = "Specifies instance type for EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Specifies key pair name for EC2 instance"
  type        = string
}

variable "proxied_server" {
  description = "Specifies backend server IP address where bastion will forward traffic to"
  type        = string
}
