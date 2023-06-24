

#creating ssh-key

resource "aws_key_pair" "key-tf" {
  key_name = "key-tf"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks      = ["::/0"]  
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  
    ipv6_cidr_blocks      = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks      = ["::/0"]   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks      = ["::/0"]   
  }

}

#resource "aws_vpc" "my_vpc" {
#  cidr_block = "10.0.0.0/16"  # Replace with your desired VPC CIDR block
#}

#resource "aws_subnet" "public_subnet" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.0.0/24"  # Replace with your desired subnet CIDR block
#  map_public_ip_on_launch = true
#
#   # Replace with your desired availability zone
#}

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

resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  #subnet_id     = aws_subnet.public_subnet.id
  key_name = "${aws_key_pair.key-tf.key_name}"
  

  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "HelloWorld"
  }
  user_data =  <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
EOF   
  
}