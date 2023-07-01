# Provider configuration
provider "aws" {
  region = "ca-central-1"  # Update with your desired region
}

# VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your desired VPC CIDR block

  tags = {
    Name = "ExampleVPC"
  }
}

# Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"  # Update with your desired subnet CIDR block

  tags = {
    Name = "ExampleSubnet"
  }
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
  security_group_ids = [aws_security_group.example_sg.id]
  key_name      = aws_key_pair.example_keypair.key_name
  user_data              = <<EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install python3 -y
                          sudo python3 -m pip install --user ansible
                          EOF
  tags = {
    Name = "Juju-Webserver-1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0e850bfa37f7efe88"  # Update with your desired AMI ID
  instance_type = "t2.micro"  # Update with your desired instance type
  subnet_id     = aws_subnet.example_subnet.id
  security_group_ids = [aws_security_group.example_sg.id]
  key_name      = aws_key_pair.example_keypair.key_name
  user_data              = <<EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install python3 -y
                          sudo python3 -m pip install --user ansible
                          EOF
  tags = {
    Name = "Juju-Webserver-2"
  }

  # Key Pair
resource "aws_key_pair" "example_keypair" {
  key_name   = "jujukey01072023"  # Update with your desired key pair name
  public_key = file("~/.ssh/id_rsa.pub")  # Update with your SSH public key path
}
}


