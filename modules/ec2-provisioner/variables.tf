################################################################################
# General settings
################################################################################

variable "aws_region" {
  description = "The AWS region where the resources are created."
  type        = string
  default     = "eu-west-2"
}

variable "bucket_name" {
  description = "S3 bucket name to get website from"
  type        = string
}

################################################################################
# EC2 settings
################################################################################

variable "host" {
  description = "EC2 instance IP address to connect to"
  type        = string
}

variable "user" {
  description = "User to authenticate against the host"
  type        = string
  default     = "ubuntu"
}

variable "private_key" {
  description = "SSH private key which used to connect to EC2 instance"
  type        = string
}

variable "proxy_host" {
  description = "The proxy host IP address"
  type        = string
  default     = null
}

variable "proxy_user" {
  description = "User to authenticate against the proxy host"
  type        = string
  default     = "ubuntu"
}

variable "proxy_private_key" {
  description = "SSH private key which used to connect to the proxy host"
  type        = string
  default     = null
}

################################################################################
# Log settings
################################################################################

variable "cloudwatch_log_group_name" {
  description = "Cloudwatch log group name to send docker container logs to"
  type        = string
}

################################################################################
# Container settings
################################################################################

variable "container_image" {
  description = "Specifies Docker image to deploy"
  type        = string
  default     = "nginx:alpine"
}
