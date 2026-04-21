variable "vpc_id" {
  type = string
}

variable "security_group_rules_alb" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = {

    "http"  = { port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTP traffic from anywhere" }
    "https" = { port = 443, protocol = "tcp", cidr_blocks = ["203.0.113.0/24"], description = "Allow HTTPS traffic from trusted IP range" }


  }
}

variable "security_group_rules_ec2_asg" {
  type = map(object({
    port        = number
    protocol    = string
    description = string
  }))
  default = {

    "http"  = { port = 80, protocol = "tcp", description = "Web traffic from ALB only" }
    "https" = { port = 443, protocol = "tcp", description = "Allow HTTPS traffic from trusted IP range" }


  }
}

variable "security_group_rules_rds" {
  type = map(object({
    port        = number
    protocol    = string
    description = string
  }))
  default = {

    "mysql" = { port = 3306, protocol = "tcp", description = "Allow MySQL traffic from EC2 instances and ALB only" }
    "https" = { port = 443, protocol = "tcp", description = "Allow HTTPS traffic for updates, etc." }


  }

}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Project     = "Three-Tier-Infra"
  }
}