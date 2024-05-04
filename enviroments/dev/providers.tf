###########################################
# AWS PROVIDER
###########################################
provider "aws" {
  region = "us-east-1"
}

# ##########################################
# # S3 BACKEND
# ##########################################
# terraform {
#   backend "s3" {
#     bucket = "s3-finalproject-bekaiym"
#     key    = "enviroments/dev/terraform.tfstate"
#     region = "us-east-1"
#     # dynamodb_table = "terraform-state-lock"
#   }
# }
