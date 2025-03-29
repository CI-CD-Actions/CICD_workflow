resource "aws_vpc" "cicd_vpc" {
  cidr_block = "10.11.0.0/16"
  tags = {
    Name = "cicd_vpc"
  }
}
variable "inbound" {   #provide port valuesrequired based on the project - inbound
  type = list(string)
  default = ["22","443", "8080","80"]  # always list 
}
variable "outbound" {    #provide port valuesrequired based on the project - outbound
  type = list(string)
  default = ["0"]   # always list 
}
resource "aws_security_group" "cicd_sg" {
  vpc_id = aws_vpc.cicd_vpc.id    # assigning vpc id to security group
  tags = {
    Name = "cicd_sg"
  }
  dynamic "ingress" {           # creating inbound rules to SG
    for_each = tolist(var.inbound)
    iterator = port
    content {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = port.value
        from_port = port.value
        protocol = "tcp"
    }
  }
  dynamic "egress" {          # creating outbound rules to SG
    for_each = tolist(var.outbound)
    iterator = port
    content {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = port.value
        from_port = port.value
        protocol = "tcp"
    }
  }
}
resource "aws_subnet" "cicd_subnet" {       # creating subnet to vpc
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = "10.11.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "cicd-subent"
  }
}
output "cicd_subnet" {                   #fetching output for reusing the value in child module
  value = aws_subnet.cicd_subnet.id
}
output "cicd_sg" {                #fetching output for reusing the value in child module
  value = aws_security_group.cicd_sg.id
}
