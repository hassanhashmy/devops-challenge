data "aws_availability_zones" "available" {}

locals {
  name = var.name

  bucket_name = var.bucket_name != null ? var.bucket_name : local.name

  vpc_id    = var.vpc_id != null ? var.vpc_id : try(module.vpc[0].vpc_id, null)
  subnet_id = var.subnet_id != null ? var.subnet_id : try(module.vpc[0].public_subnets[0], null)

  vpc_cidr          = var.vpc_cidr
  number_of_subnets = min(length(data.aws_availability_zones.available.names), var.number_of_subnets)
  azs               = slice(data.aws_availability_zones.available.names, 0, local.number_of_subnets)

  tags = merge({ Name = local.name }, var.tags)
}

################################################################################
# S3
################################################################################

resource "aws_s3_bucket" "main" {
  bucket = "${local.bucket_name}-${random_id.main.hex}"

  tags = local.tags
}

resource "aws_s3_object" "main" {
  for_each = fileset("${path.module}/files/s3_bucket_files/", "**")

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "${path.module}/files/s3_bucket_files/${each.value}"

  source_hash = filemd5("${path.module}/files/s3_bucket_files/${each.value}")
}

################################################################################
# CloudWatch
################################################################################

module "cloudwatch_dashboard" {
  source = "../../modules/cloudwatch-dashboard"

  name = local.name

  instance_id = module.ec2.id
  aws_region  = var.aws_region

  tags = local.tags
}

################################################################################
# Creates nginx docker container, and uploads S3 objects to nginx webroot
################################################################################

module "provisioner" {
  source = "../../modules/ec2-provisioner"

  host        = module.ec2.public_ip
  private_key = module.key_pair.private_key_openssh

  bucket_name = aws_s3_bucket.main.id

  cloudwatch_log_group_name = module.cloudwatch_dashboard.cloudwatch_log_group_name
}

################################################################################
# EC2
################################################################################

module "ec2" {
  source = "../../modules/ec2"

  name = local.name

  vpc_id                    = local.vpc_id
  subnet_id                 = local.subnet_id
  key_name                  = module.key_pair.key_pair_name
  bucket_name               = aws_s3_bucket.main.id
  cloudwatch_log_group_name = module.cloudwatch_dashboard.cloudwatch_log_group_name
  iam_instance_profile      = var.iam_instance_profile

  tags = local.tags
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = ">= 2.0.2"

  key_name           = "${local.name}-${random_id.main.hex}"
  create_private_key = true
}

################################################################################
# Network and Security
################################################################################

module "vpc" {
  count = var.vpc_id == null ? 1 : 0

  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = var.enable_nat_gw
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  tags = local.tags
}

################################################################################
# Secrets
################################################################################

resource "aws_ssm_parameter" "key_pair" {
  name  = "/ssh/key_pair/${module.key_pair.key_pair_name}/private_key_openssh"
  type  = "SecureString"
  value = module.key_pair.private_key_openssh

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

resource "random_id" "main" {
  byte_length = 4
}
