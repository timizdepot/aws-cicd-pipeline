variable dockerhub_credentials{
    type = string
}

variable codestar_connector_credentials {
    type = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  default = "10.6.0.0/16"
}

variable "public_subnet1_cidr_block" {
  description = "Public Subnet 1 CIDR"
  default = "10.6.1.0/24"
}

variable "public_subnet2_cidr_block" {
  description = "Public Subnet 2 CIDR"
  default = "10.6.2.0/24"
}

variable "private_subnet1_cidr_block" {
  description = "Private Subnet 1 CIDR"
  default = "10.6.3.0/24"
}

variable "private_subnet2_cidr_block" {
  description = "Private Subnet 2 CIDR"
  default = "10.6.4.0/24"
}

variable "public_subnet1_az" {
  description = "Public Subnet 1 Availability Zone"
  default = "us-east-1a"
}

variable "public_subnet2_az" {
  description = "Public Subnet 2 Availability Zone"
  default = "us-east-1b"
}


variable "private_subnet1_az" {
  description = "Private Subnet 1 Availability Zone"
  default = "us-east-1c"
}

variable "private_subnet2_az" {
  description = "Private Subnet 2 Availability Zone"
  default = "us-east-1d"
}

variable "key_path" {
  description = "Public Key path"
}

variable "ami1" {
  description = "Redhat Linux Image"
  default = "ami-0b0af3577fe5e3532"
}

variable "ami2" {
  description = "Ubuntu Linux Image"
  default = "ami-04505e74c0741db8d"
}

variable "instance_type" {
  description = "Server Instance Type"
  default = "t2.micro"
}

variable "engine" {
  description = "RDS Engine"
  default = "mysql"
}

variable "db_name" {
  description = "Database Name"
  default = "mydb"
}

variable "db_username" {
  description = "Database Username"
}

variable "db_password" {
  description = "Database Password"
}

variable "root_block_device" {
  description = "root block device"
  volume_size           = "30"
  volume_type           = "gp2"
  encrypted             = false
  delete_on_termination = true
    
}