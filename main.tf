provider "aws" {
  region    =  var.region
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0427090fd1714168b" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "WebServer"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' -u ec2-user --private-key ${var.ssh_key_path} ansible/playbook.yml"
  }


  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' -u ec2-user --private-key ${var.ssh_key_path} playbook.yml"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
