output "nat_gateway_ids" {
  value = aws_nat_gateway.public_nat[*].id
}

