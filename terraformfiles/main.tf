provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "cicdbucket2903"  # Replace with your S3 bucket name
    key            = "terraform/state.tfstate"      # Path inside S3
    region         = "us-east-1"                    # Change to your region
    encrypt        = true
    #dynamodb_table = "terraform-lock"               # Optional for state locking
  }
}


module "aws_ami" {    # calling ami module to get the AMI ID
  source = "./datasource"
}
module "module_vpc" { # calling vpc module to get the details
  source = "./vpc"
}

resource "aws_instance" "my_ec2_system" {
  ami             = module.aws_ami.ami_id
  instance_type   = "t2.micro"
  key_name        = "CICD_Server"
  vpc_security_group_ids = [ module.module_vpc.cicd_sg ] #security group assigned
  subnet_id = module.module_vpc.cicd_subnet  # updated subnet group
  count=2
  tags = {
    Name = "cicd-ec2-machine"
  }
}

