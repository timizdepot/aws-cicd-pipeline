variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "instance_type" {
  type        = string
  description = "RDS instance type and size"
}

# variable "db_cidr_block" {
#   type        = list(string)
#   description = "RDS instance cidr block"
# }

variable "subnets" {
  type        = list(string)
  description = "subnets to assign to RDS databases"
}

variable "security_groups" {
  type        = list(string)
  description = "security groups to assign to database"
  default     = []
}

variable "master_username" {
  type        = string
  description = "aurora cluster master username"
}

variable "master_password" {
  type        = string
  description = "aurora cluster master password"
}