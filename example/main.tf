provider "aws" {
  region = "ap-northeast-1"
}

variable "hoge_instance_type" {
  default = "t2.micro"
}

locals {
  tag_name = "poyoyo"
}

resource "aws_instance" "hoge" {
  vpc_security_group_ids = [aws_security_group.hoge_sg.id]
//  ami = data.aws_ami.amazon_linux.image_id
  ami = "ami-0bcc04d20228d0cf6"
  instance_type = var.hoge_instance_type
  tags = {
    Name = local.tag_name
    Group = var.group_name == "" ? "hoge" : "fuga"
  }

  user_data = data.template_file.user_data.rendered
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}

output "hoge_instance_id" {
  value = aws_instance.hoge.id
}

output "aws_instance_hoge_ami" {
  value = aws_instance.hoge.ami
}

output "aws_instance_public_dns" {
  value = aws_instance.hoge.public_dns
}

resource "aws_security_group" "hoge_sg" {
  name = "hoge_sg"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // user_dataでyum installに必要dD
  egress {
    from_port = 0
    // -1 はすべてのトラフィック
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "group_name" {}

data "template_file" "user_data" {
  template = file("./user_data.sh.tpl")

  vars = {
    package = "httpd"
  }
}

output "hoge" {
  value = data.template_file.user_data.rendered
}


module "dev_server" {
  source = "./http_server"
  instance_type = "t2.micro"
}

output "module_public_dns" {
  value = module.dev_server.public_dns
}


