resource "aws_launch_template" "web-server" {
  for_each = { for ec2 in var.ec2 : ec2.id => ec2 }

  name_prefix   = "web-server-${each.value.name}-"
  image_id      = var.ami
  instance_type = each.value.instance_type

  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = each.value.name
  }
}

resource "aws_autoscaling_group" "web-server-asg" {
  for_each = aws_launch_template.web-server

  name_prefix = "asg-${each.value.tags["Name"]}-"

  launch_template {
    id      = each.value.id
    version = "$Latest"
  }

  min_size         = var.template_value.min
  max_size         = var.template_value.max_size
  desired_capacity = var.template_value.desired_capacity

  vpc_zone_identifier = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "asg-${each.value.tags["Name"]}"
    propagate_at_launch = true
  }
}