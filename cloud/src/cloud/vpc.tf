module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "app-vpc"

  cidr = var.vpc_cidr_block

  azs             = var.deployed_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_ipv6          = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}

