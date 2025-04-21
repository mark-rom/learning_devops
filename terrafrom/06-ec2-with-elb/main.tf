resource "aws_default_vpc" "default" {

}

# HTTP Server -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

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
  # from_port         = 0
  # to_port           = 0
  cidr_ipv4 = "0.0.0.0/0"
  tags = {
    name = "http_server_sg"
  }
}


resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  vpc_id = aws_default_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    name = "elb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "elb_sg_http_ingress" {
  security_group_id = aws_security_group.elb_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    name = "elb_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "elb_sg_egress" {
  security_group_id = aws_security_group.elb_sg.id
  ip_protocol       = "-1"
  # from_port         = 0
  # to_port           = 0
  cidr_ipv4 = "0.0.0.0/0"
  tags = {
    name = "elb_sg"
  }
}

resource "aws_elb" "elb" {
  name            = "elb"
  subnets         = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = toset(values(aws_instance.http_servers).*.id)

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

# to keep in mind: servers are immutable,
# so it is better to destroy them and create again
resource "aws_instance" "http_servers" {
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  # create an ec2 instance for each available subnet
  for_each  = toset(data.aws_subnets.default_subnets.ids)
  subnet_id = each.value
  # subnet_id = data.aws_subnets.default_subnets.ids[0]

  tags = {
    name : "https_servers_${each.value}"
  }

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