variable "instance_type" {}

resource "aws_instance" "http_instance" {
  vpc_security_group_ids = [aws_security_group.http_sg.id]
  ami = "ami-0bcc04d20228d0cf6"
  instance_type = var.instance_type

  tags = {
    Name = "module_instance"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}

resource "aws_security_group" "http_sg" {
  name = "httpd_sg"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_dns" {
  value = aws_instance.http_instance.public_dns
}