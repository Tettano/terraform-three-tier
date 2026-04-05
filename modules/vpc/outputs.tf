output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "public_subnet_ids" {
  # This loops through the created subnets and extracts just the IDs
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "vpc_public_tags" {
  value = [for s in aws_subnet.public : s.tags]
}