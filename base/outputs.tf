# outputs.tf - Output values
output "vpc_id" {
  description = "ID of the created VPC"
  value       = "aws_vpc.main.id"
}