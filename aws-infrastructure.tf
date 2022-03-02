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
    description      = "HTTP"
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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

# resource "aws_instance" "wb1" {
#   ami               = "${var.ami2}"
#   instance_type     = "${var.instance_type}"
#   availability_zone = "${var.public_subnet1_az}"
#   key_name          = "dansweet"
#   vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
#   subnet_id = "${aws_subnet.public-subnet1.id}"
#   associate_public_ip_address = true
#   user_data = "${file("jenkins.sh")}"
#   # network_interface {
#   #   device_index = 0
#   #   network_interface_id = aws_network_interface.ani.id
#   # }
#   tags = {
#     Name = "jenkins-server"
#   }
#   root_block_device {
#     volume_size           = "30"
#     volume_type           = "gp2"
#     encrypted             = false
#     delete_on_termination = true
#   }
# }

# resource "aws_instance" "wb2" {
#   ami               = "${var.ami2}"
#   instance_type     = "${var.instance_type}"
#   availability_zone = "${var.public_subnet2_az}"
#   key_name          = "dansweet"
#   vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
#   subnet_id = "${aws_subnet.public-subnet2.id}"
#   associate_public_ip_address = true
#   user_data = "${file("tomcat.sh")}"

#   tags = {
#     Name = "tomcat-server"
#   }
#   # root disk
#   root_block_device {
#     volume_size           = "30"
#     volume_type           = "gp2"
#     encrypted             = false
#     delete_on_termination = true
#   }
# }

# resource "aws_instance" "wb3" {
#   ami               = "${var.ami2}"
#   instance_type     = "${var.instance_type}"
#   availability_zone = "${var.public_subnet1_az}"
#   key_name          = "dansweet"
#   vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
#   subnet_id = "${aws_subnet.public-subnet1.id}"
#   associate_public_ip_address = true
#   user_data = "${file("ansible.sh")}"
#   # network_interface {
#   #   device_index = 0
#   #   network_interface_id = aws_network_interface.ani.id
#   # }
#   tags = {
#     Name = "ansible-master"
#   }
#   root_block_device {
#     volume_size           = "30"
#     volume_type           = "gp2"
#     encrypted             = false
#     delete_on_termination = true
#   }
# }

# resource "aws_instance" "wb4" {
#   ami               = "${var.ami2}"
#   instance_type     = "${var.instance_type}"
#   availability_zone = "${var.public_subnet2_az}"
#   key_name          = "dansweet"
#   vpc_security_group_ids = ["${aws_security_group.wpsg.id}"]
#   subnet_id = "${aws_subnet.public-subnet2.id}"
#   associate_public_ip_address = true
#   user_data = "${file("nginx.sh")}"
#   # network_interface {
#   #   device_index = 0
#   #   network_interface_id = aws_network_interface.ani.id
#   # }
#   tags = {
#     Name = "nginx"
#   }
#   root_block_device {
#     volume_size           = "30"
#     volume_type           = "gp2"
#     encrypted             = false
#     delete_on_termination = true
#   }
# }

resource "aws_sns_topic" "db_alarms" {
  name = "aurora-db-alarms"
}

module "aurora_db_57" {
  source  = "claranet/aurora/aws"
  version = "x.y.z"

  engine                              = "aurora-mysql"
  engine-version                      = "5.7.12"
  name                                = "test-aurora-db-57"
  envname                             = "test-57"
  envtype                             = "test"
  subnets                             = module.vpc.private_subnet_ids
  azs                                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  replica_count                       = "1"
  security_groups                     = [aws_security_group.allow_all.id]
  instance_type                       = "db.t2.micro"
  username                            = "root"
  password                            = "changeme"
  backup_retention_period             = "5"
  final_snapshot_identifier           = "final-db-snapshot-prod"
  storage_encrypted                   = "true"
  apply_immediately                   = "true"
  monitoring_interval                 = "10"
  cw_alarms                           = "true"
  cw_sns_topic                        = aws_sns_topic.db_alarms.id
  db_parameter_group_name             = aws_db_parameter_group.aurora_db_57_parameter_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id
  iam_database_authentication_enabled = "true"
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "test-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "test-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-57-cluster-parameter-group"
}