# Final Project - Terraform - Bekaiym Egemkulova
Terraform project with best practice, meta-arguments, terraform remote state, data blocks and etc.


> [!NOTE]
> #### 👽 Instances created in Modules directory are with HEALTHY target checks, yahoo! :>
> </detalis>


```
final-project/
│
├── modules/
│   ├── networking/
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── autoscaling/
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── environments/
│   ├── prod/
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── data.tf
│   │   └── outputs.tf
│   │
│   └── dev/
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── data.tf
│   │   └── outputs.tf
│
├── .gitignore
└── README.md
```

# Project Structure Description

### 1. Root Level
- `.gitignore`: ignores big and medium files and folders created by Terraform.

### 2. Modules
- `networking/`: The networking module for VPC, Public and Private Subnets, CIDR blocks, IGW, NAT, EIP, Route Tables and Associations.
- `autoscaling/`: The autoscaling module for Launch Template, User Data, Security Groups and Supplementary Security Group, ALB, Target Group, Listener, Autoscaling Group.

Each module contains:
- `main.tf`: Configuration for that specific module.
- `variables.tf`: Module-specific variables.
- `outputs.tf`: Output values specific to that module.
- `README.md`: Brief description to that module.

### 3. Environments
- `prod/`: Environment-specific configurations for production. S3 bucket and static website.
- `dev/`: Environment-specific configurations for development. Networking and Autoscaling modules are used.

Each environment includes:
- `main.tf`: Configuration specific to that environment.
- `variables.tf`: Environment-specific variables.
- `outputs.tf`: Environment-specific outputs.
- `providers.tf`: Provider-specific outputs.

## This module will create:
- _VPC_
- _Public Subnets_
- _Private Subnets_
- _Internet Gateway_
- _NAT Gateway_
- _Elastic IP for NAT_
- _Private and Public Route Tables_
- _Launch Template_
- _Autoscaling Group_
- _Application Load Balancer_
- _Target Group_
- _Listener_
- _and etc._


## Usage:

```bash
export AWS_ACCESS_KEY_ID=<write your access key id>
export AWS_SECRET_ACCESS_KEY=<write you secret access key>
export AWS_DEFAULT_REGION=<write default region to create resource in>
```

Then perform the following commands on the root folder:
- `terraform init` terraform initialization
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply infrastructure build
- `terraform destroy` to destroy the infrastructure


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.71.0 |
