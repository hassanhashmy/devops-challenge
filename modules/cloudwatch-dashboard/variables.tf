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

################################################################################
# EC2 settings
################################################################################

variable "instance_id" {
  description = "EC2 instance id to create a CloudWatch dashboard for"
  type        = string
}
