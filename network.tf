
# module "vpc" {
#   source = "./modules/vpc"

#   infra_env        = var.infra_env
#   project          = local.tags.project
#   vpc_name         = "${local.tags.project}-vpc-${var.infra_env}"
#   vpc_cidr         = "10.2.0.0/16"
#   azs              = ["us-east-2a", "us-east-2b", "us-east-2c"]
#   public_subnets   = slice(cidrsubnets("10.2.0.0/16", 6, 6, 6), 0, 3)
#   private_subnets  = slice(cidrsubnets("10.2.0.0/16", 6, 6, 6, 6, 6, 6), 3, 6)
#   database_subnets = slice(cidrsubnets("10.2.0.0/16", 6, 6, 6, 6, 6, 6, 6, 6, 6), 6, 9)
#   tags             = local.tags
#   myip             = "71.163.242.10/32"
# }