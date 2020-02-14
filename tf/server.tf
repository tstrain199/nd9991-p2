resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["192.168.10.0/24"]
    }

    egress { # SQL Server
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress { # MySQL
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = "[0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "WebServerSG"
    }
}

resource "aws_security_group" "jump" {
    name = "vpc_jump"
    description = "Allow incoming SSH connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["192.168.10.0/24"]
    }

    egress { # SQL Server
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "JumpServerSG"
    }
}
