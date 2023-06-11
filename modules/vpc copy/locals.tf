locals {
    tags = {
      company = "timiz"
      owner = "timiz DevOps Team"
      Environment = var.infra_env
      ManagedBy   = "terraform"
      time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())    
    }
    # workspace={
    # # infra_env = terraform.workspace
    # #infra_env = terraform.workspace == "default" ? "dev" : terraform.workspace
    # }
}
