variable "rds" {
  type = map(object({
    allocated_storage      = number
    db_name                = string
    engine                 = string
    engine_version         = string
    instance_class         = string
    parameter_group_family = string
    skip_final_snapshot    = bool
    multi_az               = bool
    sensitive              = bool
    storage_encrypted      = bool



  }))
  default = {

    "myrds" = {
      allocated_storage      = 20,
      db_name                = "mydb",
      engine                 = "mysql",
      engine_version         = "8.0.35",
      instance_class         = "db.t3.small",
      parameter_group_family = "mysql8.0",
      skip_final_snapshot    = false,
      multi_az               = true,
      sensitive              = true,
      storage_encrypted      = true,

    }
  }
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security group IDs to associate with the DB instance"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for DB subnet group"
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

