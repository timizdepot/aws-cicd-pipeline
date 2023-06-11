variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "IP range to use for vpc"
  default     = "10.0.0.0/16"
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

