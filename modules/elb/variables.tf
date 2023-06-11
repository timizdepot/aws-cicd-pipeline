
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
variable "elb_name" {
  type        = string
  description = "ELB name"
}
variable "internal" {
  type        = bool
  description = "Whether ELB is internal type"
  default = false
}
variable "load_balancer_type" {
  type        = string
  description = "Describes ELB type"
  default = "application"
}
variable "deletion_protection" {
  type        = bool
  description = "Whether to enable ELB deletion protection"
  default = false
}
variable "certificate_arn" {
  type        = string
  description = "Certificate for secure HTTPS connection"
}
# variable "default_tg_arn" {
#   type        = string
#   description = "Target group to send default routing to"
# }
variable "tg_name" {
  type        = string
  description = "Target group name"
}
variable "tg_port" {
  type        = string
  description = "Target group port"
}
variable "tg_protocol" {
  type        = string
  description = "Target group protocol"
}
variable "vpc_id" {
  type        = string
  description = "VPC Id"
}
variable "health_check_path" {
  type        = string
  description = "Health check path"
  default = "/"
}
variable "host_based_priority" {
  type        = string
  description = "Host based routing priority"
}
variable "host_based_url" {
  type        = string
  description = "Host header"
}
# variable "path_pattern" {
#   type        = string
#   description = "Path pattern"
#   default = "/*"
# }
variable "route53_zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID"
}
variable "domain_name" {
  type        = string
  description = "Route53 Domain name"
}
variable "subdomain" {
  type        = string
  description = "Route53 Subdomain name"
}
