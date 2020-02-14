provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "natsg"
    }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "192.168.10.0/24"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "192.168.60.0/24"

  tags = {
    Name = "private_subnet"
  }
}

resource “aws_eip” “fornat” {
vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.fornat.id}"
  subnet_id     = "${aws_subnet.private.id}"

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public_route" {
  route_table_id         = "${aws_route_table.r.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public-rta" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "private_route" {
  route_table_id         = "${aws_route_table.private-rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.ngw.id}"
}

resource "aws_route_table_association" "private-rta" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private-rt.id}"
}
