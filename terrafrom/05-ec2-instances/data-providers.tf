data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = tolist(var.owners)
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami_ids" "aws_linux_2_latest_ids" {
  owners = tolist(var.owners)
}