resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-tf-cicd-pipeline"
  }
}

resource "aws_subnet" "public-subnet1" {
  cidr_block = "${var.public_subnet1_cidr_block}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.public_subnet1_az}"

  tags = {
    Name = "public-subnet-${var.public_subnet1_az}"
  }
}

resource "aws_subnet" "public-subnet2" {
  cidr_block = "${var.public_subnet2_cidr_block}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.public_subnet2_az}"

  tags = {
    Name = "public-subnet-${var.public_subnet2_az}"
  }
}

resource "aws_subnet" "private-subnet1" {
  cidr_block = "${var.private_subnet1_cidr_block}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.private_subnet1_az}"

  tags = {
    Name = "private-subnet-${var.private_subnet1_az}"
  }
}

resource "aws_subnet" "private-subnet2" {
  cidr_block = "${var.private_subnet2_cidr_block}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.private_subnet2_az}"

  tags = {
    Name = "private-subnet-${var.private_subnet2_az}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "WP Internet Gateway"
  }
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "Route table for Public subnet"
  }
}

resource "aws_route_table_association" "rt-asso-public-subnet1" {
  subnet_id = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_route_table_association" "rt-asso-public-subnet2" {
  subnet_id = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.default.id}"
}

# create security group to allow port 22, 80, and 443
resource "aws_security_group" "wpsg" {
  name = "wpsg"
  description = "Allow Incoming HTTP traffic"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
   ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["69.140.70.106/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_access"
  }
}
# resource "aws_security_group" "dbsg" {
#   name = "dbsg"
#   description = "Allow access to MySQL from WP"
#   vpc_id = "${aws_vpc.default.id}"

#   ingress {
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp"
#     security_groups = ["${aws_security_group.wpsg.id}"]
#   }

#   tags {
#     Name = "db-security-group"
#   }
# }

resource "aws_instance" "wb1" {
  ami               = "${var.ami2}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.public_subnet1_az}"
  key_name          = "dansweet"
  vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
  subnet_id = "${aws_subnet.public-subnet1.id}"
  associate_public_ip_address = true
  user_data = "${file("jenkins.sh")}"
  # network_interface {
  #   device_index = 0
  #   network_interface_id = aws_network_interface.ani.id
  # }
  tags = {
    Name = "jenkins-server"
  }
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
}

resource "aws_instance" "wb2" {
  ami               = "${var.ami1}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.public_subnet2_az}"
  key_name          = "${aws_key_pair.default.id}"
  vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
  subnet_id = "${aws_subnet.public-subnet2.id}"
  associate_public_ip_address = true
  user_data = "${file("tomcat.sh")}"

  tags = {
    Name = "tomcat-server"
  }
  # root disk
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
}