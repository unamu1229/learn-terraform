resource "aws_vpc" "hoge" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_hoge" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.hoge.id}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_fuga" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.hoge.id}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "hoge" {
  vpc_id = "${aws_vpc.hoge.id}"
}

resource "aws_route_table" "tabel_public_hoge" {
  vpc_id = "${aws_vpc.hoge.id}"
}

resource "aws_route" "route_public_hoge" {
  route_table_id = "${aws_route_table.tabel_public_hoge.id}"
  gateway_id = "${aws_internet_gateway.hoge.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_hoge_association" {
  route_table_id = "${aws_route_table.tabel_public_hoge.id}"
  subnet_id = "${aws_subnet.public_hoge.id}"
}

resource "aws_route_table_association" "public_fuga_association" {
  route_table_id = "${aws_route_table.tabel_public_hoge.id}"
  subnet_id = "${aws_subnet.public_fuga.id}"
}