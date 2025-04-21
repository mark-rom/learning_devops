# output "aws_security_group_http_server_details" {
#   value = aws_security_group.http_server_sg
# }

output "aws_instance" {
  value = values(aws_instance.http_servers).*.id
}

# output "aws_instance" {
#   value = aws_instance.http_server.id
# }

output "elb_public_dns" {
  value = aws_elb.elb.dns_name
}

output "aws_ami" {
  value = data.aws_ami.aws_linux_2_latest.id
}