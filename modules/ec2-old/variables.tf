variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "infra_role" {
  type        = string
  description = "infrastructure purpose"
}

variable "instance_ami" {
  type        = string
  description = "server image to use"
}

variable "default_region" {
  type        = string
  description = "the region this infrastructure is in"
  default     = "us-east-1"
}

variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t2.micro"
}

variable "instance_root_device_size" {
  type        = number
  description = "root block device size in GB"
  default     = 20
}

variable "subnets" {
  type        = list(string)
  description = "subnets to assign to server"
}

variable "security_groups" {
  type        = list(string)
  description = "security groups to assign to server"
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for the ec2 instance"
}

variable "create_eip" {
  type        = bool
  default     = false
  description = "whether or not to create eip for the ec2 instance"
}

variable "ssh_key" {
  type        = string
  description = "key to ssh into server"
}

variable "user_data" {
  type        = string
  description = "EC2 initialization script"
}

variable "name" {
  type        = string
  description = "EC2 iinstance name"
}