output "db_instance" {
  value = aws_db_instance.myrds
}

output "rds_db_credentials" {
  value = var.db_credentials
  sensitive = true
}