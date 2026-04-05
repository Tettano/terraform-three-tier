terraform {
  backend "s3" {
    bucket         = "terraform-state-tettano-use1" # your S3 bucket name
    key            = "terraform-three-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-use1"
    encrypt        = true
  }
}