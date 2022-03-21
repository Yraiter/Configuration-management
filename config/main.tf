provider "aws" {
    region = var.aws_region
}

data "aws_subnet_ids" "subnets" {
    vpc_id = var.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ansible-sg" {
 name        = "ansible-sg-8"
 description = "security group for ansible servers"
 vpc_id      = var.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
   from_port   = 8
   to_port     = 0
   protocol    = "icmp"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "server" {
  count = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  user_data = <<EOF
#! /bin/bash
sudo apt update && sudo apt install ansible -y
sudo apt-get install python3-pip -y
sudo pip3 install boto3

EOF

  tags = {
    Name = "Server"
  }
}

resource "aws_instance" "nodes" {
  count =2

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Node${count.index}"
    Ansible_Nodes = "True"
  }
}
