resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"
  tags = {
    Name = "nat-gateway-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "public_nat" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat_eip[count.index].allocation_id
  subnet_id     = var.public_subnet_ids[count.index]
  tags = {
    Name = "Public-${var.public_subnet_tags[count.index].Name}-nat-gateway"
  }
}

