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
variable "listener_arn" {
  type        = string
  description = "Http or Https listener arn"
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
variable "elb_dns_name" {
  type        = string
  description = "ELB DNS name"
}
variable "elb_zone_id" {
  type        = string
  description = "ELB Zone ID"
}

