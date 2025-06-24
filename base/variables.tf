# variables.tf - Variable declarations
////

variable "region" {
  description = "AWS region to deploy resources on"
  type        = string
  default     = "eu-central-1"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Test-EC2-env"
}
