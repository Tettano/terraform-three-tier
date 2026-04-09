# Security Groups for ALB and EC2 Instances

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_rules_alb
    content {
      description   = ingress.value.description
      from_port     = ingress.value.port
      to_port       = ingress.value.port
      protocol      = ingress.value.protocol
      cidr_blocks   = ingress.value.cidr_blocks
    } 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = merge(var.common_tags, { Name = "alb-sg" }) 

}


#EC2 Security Group

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-app-sg"
  vpc_id = var.vpc_id

# Web traffic from ALB only
  dynamic ingress {
    for_each = var.security_group_rules_ec2_asg
    content {
      description     = ingress.value.description
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      security_groups = [aws_security_group.alb_sg.id]  # Only from ALB
    }
    
  }


# outbound to anywhere (for updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = merge(var.common_tags, { Name = "ec2-sg" }) 

}


resource "aws_iam_role" "ec2_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



# For tomorrow create a variale for each value of ingress and egress to avoid hardcoding and make it more flexible. 
# Also add tags to the security groups for better identification using for_each and a map variable for tags.