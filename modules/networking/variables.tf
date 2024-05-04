variable "name" {
  description = "The identifier for all resources crested in this module"
  type        = string
  default     = "bekaiym"
}

variable "region" {
  description = "The region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket where the Terraform state file will be stored"
  type        = string
  default     = "s3-finalproject-bekaiym"
}

variable "key_path" {
  description = "The path to the key for storing state in the S3 bucket"
  type        = string
  default     = "modules/networking/terraform.tfstate"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the Public Subnets"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the Private Subnets"
  default = [
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
}

variable "availability_zones" {
  description = "The AZs in Virginia region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

