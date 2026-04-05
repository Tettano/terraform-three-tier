variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_subnet_tags" {
  type    = list(map(string))
  default = []
}