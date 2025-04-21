variable "aws_key_pair" {
  # key pair for server connection created separately
  default = "~/aws/aws_keys/default-ec2.pem"
}

variable "owners" {
  default = ["amazon"]
}

variable "region" {
  default = "us-east-1"
  type    = string
}