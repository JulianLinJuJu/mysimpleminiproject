# Provider configuration
/*provider "aws" {
  region = "ca-central-1"  # Update with your desired region
}
*/

# VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your desired VPC CIDR block
  enable_dns_hostnames = true
  tags = {
    Name = "JujuVPC"
  }
}

# Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"  # Update with your desired subnet CIDR block
  availability_zone = "ca-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "JujuSubnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "JujuIGW"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example_vpc.id

 # Create a route to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "JujuRouteTable"
  }
}

# Associate the route table with the public subnets
resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update with your desired SSH access restrictions
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

# EC2 Instances
resource "aws_instance" "instance1" {
  ami           = "ami-0e850bfa37f7efe88"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  key_name      = "jujukey01072023"

  tags = {
    Name = "Juju-Webserver-1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0e850bfa37f7efe88"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  key_name      = "jujukey01072023"
  tags = {
    Name = "Juju-Webserver-2"
  }
}

resource "aws_instance" "instance3" {
  ami           = "ami-0e850bfa37f7efe88"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  key_name      = "jujukey01072023"
  user_data              = <<EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install python3 -y
                          sudo python3 -m pip install --user ansible
                          EOF
  tags = {
    Name = "Juju-AnsibleServer-2"
  }
}




