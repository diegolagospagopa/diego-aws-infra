locals {
  project_name = "${var.environment}-diego-lab"

  south_europe_az1 = "eu-south-1a"
  south_europe_az2 = "eu-south-1b"

  eks_name = "${local.project_name}-eks"
  env      = var.environment
}

variable "aws_region" {
  type        = string
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
