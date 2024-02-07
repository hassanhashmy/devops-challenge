locals {
  name = var.name

  associate_public_ip_address = var.private ? false : true
  create_iam_instance_profile = var.iam_instance_profile == null ? true : false

  user_data = <<EOF
#!/bin/bash
# Add Docker's official GPG key:
apt-get update -y
apt-get install -y ca-certificates curl unzip
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y

# Install docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add ubuntu user to docker group to allow it runs docker command
usermod -aG docker ubuntu

# Get awscli
cd /tmp/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm awscliv2.zip
rm -rf ./aws/
  EOF

  tags = merge({ Name = local.name }, var.tags)
}

################################################################################
# Data source
################################################################################

data "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

data "aws_cloudwatch_log_group" "this" {
  name = var.cloudwatch_log_group_name
}

################################################################################
# EC2
################################################################################

// Instance Profile for EC2 instance(s)

resource "aws_iam_instance_profile" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  name = "${local.name}-profile-${random_id.this.hex}"
  role = aws_iam_role.this[0].name
}

resource "aws_iam_policy" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  name        = "${local.name}-policy-${random_id.this.hex}"
  description = "EC2 instance profile policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
         "s3:ListAllMyBuckets"
       ],
       "Effect": "Allow",
       "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.this.arn}",
        "${data.aws_s3_bucket.this.arn}/*"
       ]
    },
    {
      "Action": [
        "logs:GetLogEvents",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "${data.aws_cloudwatch_log_group.this.arn}:log-stream:*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${data.aws_cloudwatch_log_group.this.arn}:*"
    }
  ]
}
  EOT
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  name               = "${local.name}-role-${random_id.this.hex}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// EC2 security group

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-ec2-${random_id.this.hex}"
  description = "Security Group for EC2 instance Egress"

  vpc_id = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

// EC2 instance

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = "${local.name}-${random_id.this.hex}"

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = var.subnet_id

  associate_public_ip_address = local.associate_public_ip_address

  iam_instance_profile        = var.iam_instance_profile
  create_iam_instance_profile = local.create_iam_instance_profile
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = (local.create_iam_instance_profile == false ?
    {} :
    {
      // allows EC2 instance read write access to S3 bucket
      S3Access = try(aws_iam_policy.this[0].arn, null)
      // provides access through using AWS SSM Session Manager
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  })

  // Bootstrap with Docker installation
  user_data                   = local.user_data
  user_data_replace_on_change = true

  tags = var.tags
}

// Get latest AMI ids for Ubuntu Jammy 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################################################################
# Supporting resources
################################################################################

resource "random_id" "this" {
  byte_length = 4
}
