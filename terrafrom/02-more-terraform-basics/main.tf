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

variable "iam_user_name_prefix" {
  default = "my_iam_user"
  type    = string # any, number, bool, list, map, set, object, tuple
}

resource "aws_iam_user" "my_iam_users" {
  count = 3
  name  = "${var.iam_user_name_prefix}_${count.index}"
}