resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.common_tags, { Name = "RDS Subnet Group" })
}

resource "aws_db_parameter_group" "rds" {
  for_each = var.rds

  family = each.value.parameter_group_family
  name   = "rds-param-group-${each.key}"
  tags   = merge(var.common_tags, { Name = "RDS Parameter Group - ${each.key}" })
}

resource "aws_db_instance" "myrds" {
  for_each = var.rds

  allocated_storage      = each.value.allocated_storage
  db_name                = each.value.db_name
  engine                 = each.value.engine
  engine_version         = each.value.engine_version
  instance_class         = each.value.instance_class
  username               = var.db_credentials.username
  password               = var.db_credentials.password
  skip_final_snapshot    = each.value.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  parameter_group_name   = aws_db_parameter_group.rds[each.key].name
  delete_automated_backups = each.value.delete_automated_backups
  multi_az               = each.value.multi_az
  vpc_security_group_ids = var.vpc_security_group_ids
  storage_encrypted      = each.value.storage_encrypted
  storage_type           = each.value.storage_type

  tags = merge(var.common_tags, { Name = "RDS Instance - ${each.key}" })
}