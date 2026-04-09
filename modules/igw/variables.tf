variable "vpc_id" {
  description = "The VPC ID to attach the Internet Gateway to"
  type        = string
}

variable "igw_tags" {
  description = "Tags to apply to the Internet Gateway"
  type        = map(string)
  default     = {}
}