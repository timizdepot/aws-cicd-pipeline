variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "project" {
  type        = string
  description = "project name"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "vpc_cidr" {
  type        = string
  description = "IP range to use for vpc"
  default     = "10.0.0.0/16"
}
variable "myip" {
  type        = string
  description = "My IP address to use for bastion sg"
  default     = "71.163.242.10/32"
}

variable "azs" {
  type        = list(string)
  description = "AZs for subnet"
}

variable "public_subnets" {
  type        = list(string)
  description = "subnets to create for public traffic, one per az"
}

variable "private_subnets" {
  type        = list(string)
  description = "subnets to create for private traffic, one per az"
}

variable "database_subnets" {
  type        = list(string)
  description = "subnets to create for database traffic, one per az"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for the ec2 instance"
}
