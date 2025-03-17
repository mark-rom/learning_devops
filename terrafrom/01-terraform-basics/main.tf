terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.89.0"
    }
  }
}
provider "aws" {
    region = "us-east-1"
    # access_key = "$AWS_ACCESS_KEY_ID"
    # secret_key = "$AWS_SECRET_ACCESS_KEY"
}

# plan - execute
