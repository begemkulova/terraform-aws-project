###########################################
# AWS PROVIDER
###########################################
provider "aws" {
  region = var.region
}

###########################################
# S3 BACKEND
###########################################
terraform {
  backend "s3" {
    bucket = "s3-finalproject-bekaiym"
    key    = "modules/autoscaling/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
  }
}

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
# Get the latest AWS Linux 2 image
###########################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["137112412989"] # Amazon
}

###########################################
# Launch Template & User Data
###########################################
resource "aws_launch_configuration" "asg_config" {
  name                        = "terraform-asg-bekaiym"
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.asg_sg.id]
  associate_public_ip_address = false #true

  user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
                AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
                REGION=$${AVAILABILITY_ZONE::-1}
                echo "<h1>Final Project Terraform by Bekaiym Egemkulova</h1>" | sudo tee /var/www/html/index.html
                echo "<p>Instance ID: $INSTANCE_ID</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Region: $REGION</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Availability Zone: $AVAILABILITY_ZONE</p>" | sudo tee -a /var/www/html/index.html
                sudo systemctl restart httpd
                EOF
  )
  lifecycle {
    create_before_destroy = true
  }
}

###########################################
# Launch the ALB in the public subnets
###########################################
resource "aws_lb" "bekaiym" {
  name               = "bekaiym-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.networking.outputs.public_subnet_ids

  # enable_deletion_protection = true
}

###########################################
# Target Group
###########################################
resource "aws_lb_target_group" "bekaiym" {
  name     = "bekaiym"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.networking.outputs.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
    path                = "/"
    port                = "traffic-port"
  }
}

###########################################
# Listener
###########################################
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.bekaiym.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bekaiym.arn
  }
}

###########################################
# Launch the ASG in the private subnets
###########################################
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.asg_config.name
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = data.terraform_remote_state.networking.outputs.private_subnet_ids

  # Associate ASG with ALB Target Group
  target_group_arns = [aws_lb_target_group.bekaiym.arn]

  tag {
    key                 = "Name"
    value               = "Bekaiym - ASG Instances"
    propagate_at_launch = true
  }
}

###########################################
# Create a Security Group for the ALB
###########################################
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound traffic from anywhere on port 22, 80 and 443"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id


  dynamic "ingress" {
    for_each = [22, 80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

###########################################
# Create a Security Group for instances in the ASG
###########################################
resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "Allow inbound traffic on port 80 from the ALB only"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg_sg"
  }
}
