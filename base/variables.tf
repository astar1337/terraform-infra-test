# variables.tf - Variable declarations
////
//REGION
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
//CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}