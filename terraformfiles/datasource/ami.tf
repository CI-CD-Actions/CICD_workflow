data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]  # Canonical's AWS account ID
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}
