output "vpc_id" {
  description = "VPC ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "nat_public_ips" {
  description = "VPC NAT gateway public ips"
  value       = module.vpc.nat_public_ips
}

output "vpc_cidr_block" {
  description = "10.0.0.0/16"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "VPC subnet IDS - private"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "VPC subnet IDS - public"
  value       = module.vpc.public_subnets
}

