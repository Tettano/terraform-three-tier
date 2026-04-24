resource "aws_internet_gateway" "igw" {
  tags = var.igw_tags
}

resource "aws_internet_gateway_attachment" "igw_attachment" {
  vpc_id              = var.vpc_id
  internet_gateway_id = aws_internet_gateway.igw.id
}

resource "time_sleep" "wait_for_igw_propagation" {
  create_duration = "10s"
  depends_on      = [aws_internet_gateway_attachment.igw_attachment]
}