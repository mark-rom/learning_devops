terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.89.0"
    }
  }
  backend "s3" {
    bucket = ""
    key = ""
    region = ""
    dynamodb_table = ""
    encrypt = true
  }
}
provider "aws" {
    region = "us-east-1"
    # access_key = "$AWS_ACCESS_KEY_ID"
    # secret_key = "$AWS_SECRET_ACCESS_KEY"
}