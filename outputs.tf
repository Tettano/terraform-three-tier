# The Main VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# All Public Subnet IDs as a List
output "public_subnet_ids" {
  description = "List of IDs for all public subnets"
  value       = module.vpc.public_subnet_ids
}

# All Private Subnet IDs as a List
output "private_subnet_ids" {
  description = "List of IDs for all private subnets"
  value       = module.vpc.private_subnet_ids
}

output "vpc_public_tags" {
  value = module.vpc.vpc_public_tags
}

# ALB DNS Name (Crucial for testing)
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.alb_dns_name # Ensure your ALB module has this output!
}