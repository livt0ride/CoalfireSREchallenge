

# Defining local variables
locals {
  vpc_cidr       = var.cidr_block
  azs            = ["us-west-2a", "us-west-2b"]
  management_cidr = "YOUR_IP/32" # Replace with your IP address
}

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "sre-challenge-vpc"
  cidr = local.vpc_cidr

  azs = local.azs
  private_subnets = [
    "10.1.1.0/24", # Application subnet AZ1
    "10.1.2.0/24", # Application subnet AZ2
    "10.1.3.0/24", # Backend subnet AZ1
    "10.1.4.0/24"  # Backend subnet AZ2
  ]
  public_subnets = [
    "10.1.5.0/24", # Management subnet AZ1
    "10.1.6.0/24"  # Management subnet AZ2
  ]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "SRE-Challenge"
  }
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id          = module.vpc.vpc_id
  management_cidr = local.management_cidr
}

# Application Module (ASG and ALB)
module "application" {
  source = "./modules/application"

  vpc_id              = module.vpc.vpc_id
  app_subnets         = module.vpc.private_subnets
  public_subnets      = module.vpc.public_subnets
  app_sg_id           = module.security_groups.app_sg_id
  alb_sg_id           = module.security_groups.alb_sg_id
}

# Management Instance Module
module "management" {
  source = "./modules/management"

  vpc_id             = module.vpc.vpc_id
  management_subnet  = module.vpc.public_subnets[0]
  management_sg_id   = module.security_groups.management_sg_id
}