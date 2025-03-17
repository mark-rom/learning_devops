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

variable "names" {
  default = ["john", "sats", "mark", "tom", "jane"]
  # prev version
  # default = ["mark", "tom", "jane"]
  type = list
}

resource "aws_iam_user" "my_iam_users" {
  for_each = toset(var.names)
  name = each.value
  # prev version
  # count = length(var.names)
  # name  = var.names[count.index]
}