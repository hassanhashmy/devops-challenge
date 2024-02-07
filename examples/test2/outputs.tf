output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.private_ip
}

output "bastion_public_ip" {
  description = "Public IP address of the proxy EC2 instance"
  value       = module.ec2_proxy.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.main.id
}
