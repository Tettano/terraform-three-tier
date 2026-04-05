output "igw_tags" {
  value = aws_internet_gateway.igw.tags_all
}

output "internet-gateway-id" {
  value = aws_internet_gateway.igw.id
}

output "internet-gateway-attached" {
  value = aws_internet_gateway_attachment.igw_attachment.id
}