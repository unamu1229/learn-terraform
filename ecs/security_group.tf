resource "aws_security_group" "web_port_enable" {
  name = "hoge-web-port"
  vpc_id = "${aws_vpc.hoge.id}"
}

resource "aws_security_group_rule" "in_web_port" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.web_port_enable.id}"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "out" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.web_port_enable.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}