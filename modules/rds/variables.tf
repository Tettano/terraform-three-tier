variable "rds" {
  type = map(object({
    allocated_storage         = number
    db_name                   = string
    engine                    = string
    engine_version            = string
    instance_class            = string
    parameter_group_family    = string
    skip_final_snapshot       = bool
    final_snapshot_identifier = string
    multi_az                  = bool
    sensitive                 = bool
    storage_encrypted         = bool
    storage_type              = string


  }))
  default = {

    "myrds" = {
      allocated_storage         = 20,
      db_name                   = "mydb",
      engine                    = "mysql",
      engine_version            = "8.4",
      instance_class            = "db.t3.small",
      parameter_group_family    = "mysql8.4",
      skip_final_snapshot       = true,
      final_snapshot_identifier = "myrds-final-snapshot",
      multi_az                  = true,
      sensitive                 = true,
      storage_encrypted         = true,
      storage_type              = "gp2"
    }
  }
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security group IDs to associate with the DB instance"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for DB subnet group"
  default     = []
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to resources"
  default     = {}
}

variable "db_credentials" {
  type = object({
    username = string
    password = string
  })
  sensitive = true
  default = {
    username = "admin"
    password = "password123"
  }
}

