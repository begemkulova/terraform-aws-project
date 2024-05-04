module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}


module "autoscaling" {
  source = "../../modules/autoscaling"
  # autoscaling module is set to deploy an Apache web server with a user data script 
  # to private subnets in autoscaling directory - main.tf
  instance_type    = "t2.micro"
  min_size         = 2
  desired_capacity = 4
  max_size         = 6
}


