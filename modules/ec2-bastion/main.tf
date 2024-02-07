locals {
  name = var.name

  user_data = <<-EOT
  #cloud-config
  apt_upgrade: true

  packages:
    - python3-pip
    - nginx

  write_files:
  - content: |
      # Test writing /etc/terraform-writes
    path: /etc/terraform-writes
  - content: |
      server {
        listen     80 default_server;
        listen     [::]:80 default_server;

        server_name _;

        location / {
          proxy_pass http://${var.proxied_server};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        }
      }
    owner: root:root
    permissions: '0644'
    path: /etc/nginx/sites-available/default
  EOT

  tags = merge({ Name = local.name }, var.tags)
}

################################################################################
# EC2
################################################################################

// EC2 security group

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-bastion-${random_id.this.hex}"
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

  associate_public_ip_address = true

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    // provides access through using AWS SSM Session Manager
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

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
