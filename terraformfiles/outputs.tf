output "private_ips" {
  value = aws_instance.my_ec2_system[*].private_ip
}
