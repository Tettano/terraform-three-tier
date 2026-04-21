variable "ami" {
  type        = string
  default     = "ami-0ea87431b78a82070"  # Amazon Linux 2 AMI for us-east-1
  description = "AMI ID for the instances"
}

variable "ec2" {
  type = list(object({
    id            = string
    name          = string
    instance_type = string
  }))
  default = [
    {
      id            = "web-t2"
      name          = "web-server-t2"
      instance_type = "t2.micro"
    }
  ]
  description = "List of EC2 configurations for ASGs"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs for the ASG"
}

# variable "min_size" {
#   type        = number
#   default     = 1
#   description = "Minimum number of instances in the ASG"
# }

# variable "max_size" {
#   type        = number
#   default     = 3
#   description = "Maximum number of instances in the ASG"
# }

# variable "desired_capacity" {
#   type        = number
#   default     = 2
#   description = "Desired number of instances in the ASG"
# }   
  
variable "security_group_ids" {
  type = list(string)
  description = "List of security group for the instances"
  default = []
}

variable "template_value" {
  type = object({
    min       = number
    max_size  = number
    desired_capacity = number
  })
  default = {
    min       = 1
    max_size  = 3
    desired_capacity = 2
  }

}