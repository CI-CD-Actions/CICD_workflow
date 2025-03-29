provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "my_ec2_system" {
  ami             = "ami-084568db4383264d4"
  instance_type   = "t2.micro"
  key_name        = "key-001501e8cc53ade44"

  tags = {
    Name = "cicd-ec2-machine"
  }
}
