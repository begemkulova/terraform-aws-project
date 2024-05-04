# Module of Autoscaling
## This module will create:
- _ASG_
- _ALB_
- _Launch Template with User Data_
- _Target Group_
- _Listener_
- _Instances_
- _Associations_
- _etc._

## **Usage**
```terraform
module "autoscaling" {
  source = "../../modules/autoscaling" <= your path
  instance_type    = "t2.micro"
  min_size         = 2
  desired_capacity = 4
  max_size         = 6
}
```
#### Autoscaling module is set to deploy an Apache web server with a user data script 
#### to private subnets in autoscaling directory - main.tf

## Requirements

Terraform and AWS account.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_configuration.asg_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.bekaiym](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.bekaiym](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.asg_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket where the Terraform state file will be stored | `string` | `"s3-finalproject-bekaiym"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired size of the auto scaling group | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `"t2.micro"` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | The path to the key for storing state in the S3 bucket | `string` | `"modules/networking/terraform.tfstate"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the auto scaling group | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the auto scaling group | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The identifier for all resources crested in this module | `string` | `"bekaiym"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create resources in | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of our ALB |
