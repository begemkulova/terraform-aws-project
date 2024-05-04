###########################################
# Data block for the modules/networking/ 
###########################################
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "s3-finalproject-bekaiym"
    key    = "modules/networking/terraform.tfstate"
    region = "us-east-1"
  }
}

###########################################
# Data block for the modules/autoscaling/ 
###########################################
data "terraform_remote_state" "autoscaling" {
  backend = "s3"
  config = {
    bucket = "s3-finalproject-bekaiym"
    key    = "modules/autoscaling/terraform.tfstate"
    region = "us-east-1"
  }
}
