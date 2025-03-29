output "ec2_public_ips" {
  value = aws_instance.my_ec2_system[*].public_ip
}

output "ec2_private_ips" {
  value = aws_instance.my_ec2_system[*].private_ip
}

output "ec2_instance_ids" {
  value = aws_instance.my_ec2_system[*].id
}
