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

###########################################
# Data block for the enviroments/dev/ 
###########################################
data "terraform_remote_state" "dev" {
  backend = "s3"
  config = {
    bucket = "s3-finalproject-bekaiym"
    key    = "enviroments/dev/terraform.tfstate"
    region = "us-east-1"
  }
}


###########################################
# IAM Policy 
###########################################
data "aws_iam_policy_document" "s3_website_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
