# data "aws_vpc" "myvpc" {
#   tags = {
#     Name = "${local.tags.project}-vpc-${var.infra_env}"
#   }
# }
# data "aws_subnets" "public_subnets" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.tags.project}-vpc-${var.infra_env}-public*"]
#   }
# }
# data "aws_subnets" "private_subnets" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.tags.project}-vpc-${var.infra_env}-private*"]
#   }
# }
# data "aws_security_group" "private_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.tags.project}-private*"]
#   }
# }
# data "aws_security_group" "loadbalancer_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.tags.project}-loadbalancer*"]
#   }
# }

# data "aws_security_group" "bastion_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["${local.tags.project}-bastion*"]
#   }
# }
# data "aws_lb_listener" "http_listener" {
#   port         = 80
#   load_balancer_arn = data.aws_lb.elb.arn
# }
# data "aws_lb_listener" "https_listener" {
#   port         = 443
#   load_balancer_arn = data.aws_lb.elb.arn
# }
# data "aws_lb" "elb" {
#   name         = "${local.tags.project}-jenkinsloadbalancer-${var.infra_env}"
# }
# data "aws_iam_instance_profile" "logs" {
#   name = "${local.tags.project}-logs-iam-instance-profile"
# }
data "aws_route53_zone" "domain" {
  name         = "sewewa.com"
  private_zone = false
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"]
}

data "aws_ami" "amzn2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["137112412989"]
}