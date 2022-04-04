terraform {
  required_version = ">= 0.13.5"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "AWS VPC id"
  default     = "vpc-0bf0c91dc33c1739e"
}

variable "subnet_id" {
  description = "Ansible Subnet id"
  default     = "subnet-066ee1f94ffe95f30"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22,80,8080]
}