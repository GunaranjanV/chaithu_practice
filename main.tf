provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Guna-vpc"
  }
}

# Subnet 1
resource "aws_subnet" "publicsubnet01" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-01"
  }
}

# Subnet 2
resource "aws_subnet" "publicsubnet02" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-02"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "My-IGW"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Public-RT"
  }
}

# Default Route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

# Route Table Associations
resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.publicsubnet01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.publicsubnet02.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
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
    Name = "Web-SG"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicsubnet01.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name      = "us-key" # replace with your actual key pair name

  tags = {
    Name = "Terraform-Web-Server"
  }
}

# Output Public IP
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
