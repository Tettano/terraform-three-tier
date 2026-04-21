variable "cidr_block_main_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "use1a" = { cidr_block = "10.0.1.0/24", az = "us-east-1a" }
    "use1b" = { cidr_block = "10.0.3.0/24", az = "us-east-1b" }
  }
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "use1a" = { cidr_block = "10.0.2.0/24", az = "us-east-1a" }
    "use1b" = { cidr_block = "10.0.4.0/24", az = "us-east-1b" }
  }
}

variable "db_credentials" {
  type = object({
    username = string
    password = string
  })
  sensitive   = true
  description = "RDS Database Credentials"
  default = {
    username = "admin"
    password = "password123"
  }
}

