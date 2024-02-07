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

output "codedeploy_app" {
  description = "CodeDeploy app"
  value       = aws_codedeploy_app.main.name
}

output "codedeploy_group" {
  description = "CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.main.deployment_group_name
}
