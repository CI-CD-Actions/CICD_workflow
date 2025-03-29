provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

module "aws_ami" {    # calling ami module to get the AMI ID
  source = "../datasource"
}
module "module_vpc" { # calling vpc module to get the details
  source = "../vpc"
}

resource "aws_instance" "my_ec2_system" {
  ami             = module.aws_ami.ami_id
  instance_type   = "t2.micro"
  key_name        = "key-001501e8cc53ade44"

  tags = {
    Name = "cicd-ec2-machine"
  }
}
