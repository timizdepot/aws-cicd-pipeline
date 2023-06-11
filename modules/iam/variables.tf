variable "name" {
  type        = string
  description = "name tag value"
}

variable "tags" {
  type        = map(any)
  description = "tags for the vpc module"
}

variable "actions" {
  type        = list(string)
  description = "assume role actions"
}
