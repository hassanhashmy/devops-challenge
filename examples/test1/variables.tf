################################################################################
# General settings
################################################################################

variable "name" {
  description = "The prefix or project name which will be included in the name of most resources."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the resources are created."
  type        = string
  default     = "eu-west-2"
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "S3 bucket name to be created."
  type        = string
  default     = null
}

################################################################################
# VPC settings
################################################################################

variable "vpc_id" {
  description = "Specifies the id of an existing VPC"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Specifies the subnet id to place EC2 instance to"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "The address space used by VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "number_of_subnets" {
  description = "Specifies the number of subnets to be created"
  type        = number
  default     = 2
}

variable "enable_nat_gw" {
  description = "Specifies whether to create Nat gateway or not"
  type        = bool
  default     = true
}

################################################################################
# Security
################################################################################

variable "iam_instance_profile" {
  description = "Specifies an existing IAM instance profile name for the private instance"
  type        = string
  default     = null
}
