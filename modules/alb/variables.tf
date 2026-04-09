variable "subnet_ids" {
    type    = list(string)
    default = []
    }

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
  description = "Security group ID for the ALB"
}