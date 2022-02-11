# creating a variable
variable "subnet_prefix" {
  description = "cidr block for subnets"
  #default = "10.10.1.0/24"
  #type        = string
}
variable "cidr_range" {
  description = "cidr block range"
  #default = "10.10.1.0/24"
  #type        = string
}

# create a vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block       = var.cidr_range
  instance_tenancy = "default"

  tags = {
    Name = "dev vpc"
  }
}
# create a subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.dev-vpc.id
  #cidr_block = var.subnet_prefix
  cidr_block = var.subnet_prefix[0]
  #cidr_block = var.subnet_prefix[0].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev_subnet1"
    #Name = var.subnet_prefix[0].name
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.dev-vpc.id
  #cidr_block = var.subnet_prefix
  cidr_block = var.subnet_prefix[1]
  #cidr_block = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1b"

  tags = {
    Name  = "dev_subnet2"
    #Name = var.subnet_prefix[1].name
  }
}
resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.dev-vpc.id
  #cidr_block = var.subnet_prefix
  cidr_block = var.subnet_prefix[2]
  #cidr_block = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1c"

  tags = {
    Name  = "dev_subnet3"
    #Name = var.subnet_prefix[1].name
  }
}
# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev igw"
  }
}
# create custom route table
resource "aws_route_table" "dev-pub-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dev-pub-rt"
  }
}

# associate subnet with route table
resource "aws_route_table_association" "rta" {
  subnet_id      = [aws_subnet.subnet1.id, aws_subnet.subnet2.id,aws_subnet.subnet3.id]
  route_table_id = aws_route_table.dev-pub-rt.id
}
# create security group to allow port 22, 80, and 443
resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["69.140.70.106/32"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_access"
  }
}
# create a network interface with an ip in the subnet that was created
resource "aws_network_interface" "ani" {
  subnet_id       = [aws_subnet.subnet1.id, aws_subnet.subnet2.id,aws_subnet.subnet3.id]
  private_ips     = ["10.6.1.5","10.6.5.5","10.6.10.5"]
  security_groups = [aws_security_group.web_access.id]

  # attachment {
  #   instance     = aws_instance.web-server.id
  #   device_index = 1
  # }




}
# assign an elastic IP to the network interface
resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = aws_network_interface.ani.id
  associate_with_private_ip = ["10.6.1.5","10.6.5.5","10.6.10.5"]
  depends_on                = [aws_internet_gateway.igw,aws_vpc.dev-vpc]
}
# create an output to get the public IP address
output "server_public_ip" {
  value = aws_eip.eip.public_ip
}
# create an output to get the private IP address and instance id
output "server_private_ip" {
  value = aws_instance.web-server.private_ip
}
output "server_instance_id" {
  value = aws_instance.web-server.id
}


resource "aws_instance" "web-server" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "dansweet"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.ani.id
  }
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt full-upgrade -y
              # download jenkins and run it using java jdk 11
              add-apt-repository ppa:openjdk-r/ppa
              apt install openjdk-11-jdk -y
              wget https://updates.jenkins-ci.org/download/war/2.334/jenkins.war
              cd /opt/
              wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
              nohup java -jar jenkins.war &
              EOF

  tags = {
    Name = "jenkins-server"
  }
  # root disk
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }
}

resource "aws_instance" "tomcat-server" {
  ami               = "ami-0b0af3577fe5e3532"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1b"
  key_name          = "dansweet"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.ani.id
  }
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install java-11-openjdk.x86_64 wget -y
              wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz
              EOF

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
