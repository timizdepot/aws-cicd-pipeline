# module "iam_logs" {
#   source  = "./modules/iam"
#   name    = "${local.tags.project}-logs"
#   tags    = local.tags
#   actions = ["logs:CreateLogStream", "logs:DescribeLogStreams", "logs:CreateLogGroup", "logs:PutLogEvents"]
# }
# module "iam_jenkins" {
#   source  = "./modules/iam"
#   name    = "${local.tags.project}-jenkins"
#   tags    = local.tags
#   actions = ["*"]
# }
# module "elb_jenkins" {
#   source              = "./modules/elb"
#   elb_name            = "${local.tags.project}-jenkinsloadbalancer-${var.infra_env}"
#   internal            = false
#   load_balancer_type  = "application"
#   security_groups     = [module.vpc.loadbalancer_sg.id]
#   subnets             = module.vpc.public_subnets
#   deletion_protection = false
#   tags                = { Environment = "dev" }
#   certificate_arn     = "arn:aws:acm:us-east-2:307475751203:certificate/16eefd01-4464-466b-aa97-ab2b7486b57d"
#   tg_name             = "${local.tags.project}-jenkins-tg-${var.infra_env}"
#   tg_port             = 8080
#   tg_protocol         = "HTTP"
#   vpc_id              = module.vpc.vpc_id
#   health_check_path   = "/login"
#   host_based_priority = 1
#   host_based_url      = "jenkins.${data.aws_route53_zone.domain.name}"
#   domain_name         = data.aws_route53_zone.domain.name
#   route53_zone_id     = data.aws_route53_zone.domain.zone_id
#   subdomain           = "*"
# }

# module "jenkins" {
#   source               = "./modules/ec2"
#   name                 = "jenkins-${var.infra_env}"
#   infra_env            = var.infra_env
#   infra_role           = "infrastructure"
#   instance_ami         = data.aws_ami.amzn2.id
#   iam_instance_profile = module.iam_jenkins.aws_iam_instance_profile
#   instance_size        = "t3.medium"
#   ssh_key              = "ohio"
#   user_data            = file("./scripts/jenkins-maven-ansible.sh")
#   root_device_size     = 30
#   subnets              = module.vpc.private_subnets
#   security_groups      = [module.vpc.private_sg.id]
#   tags                 = local.tags
#   create_eip           = false
# }
# module "elb_tg_jenkins_ne" {
#   source              = "./modules/elb_tg"
#   tg_name             = "${local.tags.project}-jenkins-ne-tg-${var.infra_env}"
#   tg_port             = 9100
#   tg_protocol         = "HTTP"
#   vpc_id              = module.vpc.vpc_id
#   listener_arn        = module.elb_jenkins.http_listener_arn
#   health_check_path   = "/"
#   host_based_priority = 11
#   host_based_url      = "jenkins-ne.${data.aws_route53_zone.domain.name}"
#   domain_name         = data.aws_route53_zone.domain.name
#   route53_zone_id     = data.aws_route53_zone.domain.zone_id
#   subdomain           = "jenkins-ne"
#   elb_dns_name        = module.elb_jenkins.elb_dns_name
#   elb_zone_id         = module.elb_jenkins.elb_zone_id
# }
# resource "aws_lb_target_group_attachment" "jenkins" {
#   target_group_arn = module.elb_jenkins.target_group_arn
#   target_id        = module.jenkins.instance_id
#   port             = 8080
# }
# resource "aws_lb_target_group_attachment" "jenkins_ne" {
#   target_group_arn = module.elb_tg_jenkins_ne.target_group_arn
#   target_id        = module.jenkins.instance_id
#   port             = 9100
# }

# module "bastion" {
#   source               = "./modules/ec2"
#   name                 = "bastion-${var.infra_env}"
#   infra_env            = var.infra_env
#   infra_role           = "bastion"
#   instance_ami         = data.aws_ami.ubuntu.id
#   iam_instance_profile = module.iam_logs.aws_iam_instance_profile
#   instance_size        = "t2.micro"
#   ssh_key              = "ohio"
#   user_data            = file("./scripts/bastion.sh")
#   root_device_size     = 30
#   subnets              = module.vpc.public_subnets
#   security_groups      = [module.vpc.bastion_sg.id]
#   tags                 = local.tags
#   create_eip           = false
# }