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
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  
validation {
    condition = can(regex("^ami-[a-f0-9]{8}([a-f0-9]{9})?$", var.ami_id))
    error_message = "AMI ID must be a valid format starting with 'ami-' followed by 8 or 17 hexadecimal characters."
  }
}
output "ami_info" {
  description = "Complete AMI information"
  value = {
    id          = data.aws_ami.amazon_linux.id
    name        = data.aws_ami.amazon_linux.name
    description = data.aws_ami.amazon_linux.description
    owner_id    = data.aws_ami.amazon_linux.owner_id
    architecture = data.aws_ami.amazon_linux.architecture
    creation_date = data.aws_ami.amazon_linux.creation_date
    platform    = data.aws_ami.amazon_linux.platform
    root_device_type = data.aws_ami.amazon_linux.root_device_type
  }
}