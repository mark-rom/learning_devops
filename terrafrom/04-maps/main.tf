terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.89.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  # access_key = "$AWS_ACCESS_KEY_ID"
  # secret_key = "$AWS_SECRET_ACCESS_KEY"
}

variable "users" {
  # prev iteration
  # default = {
  #   mark: "Netherlands",
  #   tom: "US",
  #   jane: "Serbia"
  # }
  default = {
    mark : { country : "Netherlands", department : "abc" },
    tom : { country : "US", department : "def" },
    jane : { country : "Serbia", department : "xyz" }
  }
}

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  # prev iteration
  # tags = {
  #   country: each.value
  # }
  tags = {
    country : each.value.country
    department : each.value.department
  }
}