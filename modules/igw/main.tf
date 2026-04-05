resource "aws_internet_gateway" "igw" {
  tags = { Name = "main-igw" }
}

resource "aws_internet_gateway_attachment" "igw_attachment" {
  vpc_id              = var.vpc_id
  internet_gateway_id = aws_internet_gateway.igw.id
}  