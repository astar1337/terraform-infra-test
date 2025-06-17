# outputs.tf - Output values
output "vpc_id" {
  description = "ID of the created VPC"
  value       = "aws_vpc.main.id"
}
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_servers
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_servers
}

