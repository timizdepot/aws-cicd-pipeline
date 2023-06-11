module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.infra_env}-vpc"
  cidr = var.vpc_cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = merge(local.tags)
  public_subnet_tags = {
    Role = "public"
  }
  private_subnet_tags = {
    Role = "private"
  }
  database_subnet_tags = {
    Role = "database"
  }

}