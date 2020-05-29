output "vpc_id" {
  description = "VPC ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "nat_public_ips" {
  description = "VPC NAT gateway public ips"
  value       = module.vpc.nat_public_ips
}

output "vpc_cidr_block" {
  description = "VPC subnet - default 10.0.0.0/16"
  value       = module.vpc.vpc_cidr_block
}

output "db_address" {
  description = "dns location of db"
  value       = aws_db_instance.appdb.address
}

