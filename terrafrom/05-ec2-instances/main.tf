terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.89.0"
    }
  }
}

provider "aws" {
  region = var.region
  # access_key = "$AWS_ACCESS_KEY_ID"
  # secret_key = "$AWS_SECRET_ACCESS_KEY"
}

resource "aws_default_vpc" "default" {

}

# HTTP Server -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  egress  = []
  ingress = []

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_server_sg_http_ingress" {
  security_group_id = aws_security_group.http_server_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    name = "http_server_sg"
  }
}

# resource "aws_vpc_security_group_ingress_rule" "http_server_sg_https_ingress" {
#   security_group_id = aws_security_group.http_server_sg.id
#   ip_protocol = "tcp"
#   from_port = 443
#   to_port = 443
#   cidr_ipv4 = ["0.0.0.0/0"]
# }

resource "aws_vpc_security_group_ingress_rule" "http_server_sg_ssh_ingress" {
  security_group_id = aws_security_group.http_server_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    name = "http_server_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "http_server_sg_egress" {
  security_group_id = aws_security_group.http_server_sg.id
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    name = "http_server_sg"
  }
}

# to keep in mind: servers are immutable,
# so it is better to destroy them and create again
resource "aws_instance" "http_server" {
  ami             = data.aws_ami.aws_linux_2_latest.id
  key_name        = "default-ec2"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.http_server_sg.id]
  subnet_id       = data.aws_subnets.default_subnets.ids[0]

  # setup a connection to the server
  connection {
    type = "ssh"
    host = self.public_ip
    # ec2-user is a default user created with the server
    user = "ec2-user"
    # path to key pair contained in a variable
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    # execute following commands inline
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome to in28minutes - Virtual Server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}