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

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum size of the auto scaling group"
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the auto scaling group"
  default     = 5
}

variable "desired_capacity" {
  description = "The desired size of the auto scaling group"
  default     = 2
}
