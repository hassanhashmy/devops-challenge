output "ec2_public_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.main.id
}
