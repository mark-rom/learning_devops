variable "environment" {
  default = "default"
}

locals {
  # to keep some variables unchanged
  my_iam_user_extention = "my_iam_user_abc"
}

resource "aws_iam_user" "my_iam_user" {
  name = "${local.my_iam_user_extention}_${var.environment}"
}