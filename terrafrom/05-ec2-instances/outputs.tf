# output "aws_security_group_http_server_details" {
#   value = aws_security_group.http_server_sg
# }

output "aws_instance" {
  value = aws_instance.http_server.public_dns
}

output "aws_ami" {
  value = data.aws_ami.aws_linux_2_latest.id
}