resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, { Name = "RDS Subnet Group" })
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
  parameter_group_name   = each.value.parameter_group_name
  skip_final_snapshot    = each.value.skip_final_snapshot
  multi_az               = each.value.multi_az
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  storage_encrypted      = each.value.storage_encrypted

  tags = merge(var.common_tags, { Name = "RDS Instance - ${each.key}" })

}