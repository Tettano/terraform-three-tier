variable "cidr_block_main_vpc" { type = string }

variable "public_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}