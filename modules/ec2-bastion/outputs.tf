output "id" {
  description = "The EC2 instance id"
  value       = module.ec2_instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}
