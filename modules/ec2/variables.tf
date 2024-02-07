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

variable "bucket_name" {
  description = "S3 bucket name to get website from"
  type        = string
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

variable "private" {
  description = "Specifies whether to deploy EC2 instance without a public IP address"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "Specifies instance type for EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Specifies key pair name for EC2 instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name used for EC2 instance"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_name" {
  description = "Cloudwatch log group name to send docker container logs to"
  type        = string
}
