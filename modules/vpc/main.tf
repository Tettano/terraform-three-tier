resource "aws_vpc" "main-vpc" {
  cidr_block = var.cidr_block_main_vpc
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags              = { Name = "public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags              = { Name = "private-${each.key}" }
}