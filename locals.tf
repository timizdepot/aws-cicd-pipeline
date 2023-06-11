locals {
  tags = {
    company = "timiz"
    project = "tcit"
    owner   = "DevOps Team"
    # Environment = var.infra_env
    ManagedBy = "terraform"
    time      = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
  # workspace={
  # # infra_env = terraform.workspace
  # #infra_env = terraform.workspace == "default" ? "dev" : terraform.workspace
  # }
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "dev"
}