# module "k8s_master" {
#   source               = "./modules/ec2"
#   name                      = "${local.tags.project}-k8s-master-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "orchestration"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile = module.iam_jenkins.aws_iam_instance_profile
#   instance_size        = "t3.medium"
#   ssh_key              = "ohio"
#   user_data            = file("./scripts/kubernetes-new.sh")
#   root_device_size     = 30
#   subnets              = module.vpc.public_subnets.ids
#   security_groups      = [module.vpc.k8s_master_sg.id]
#   tags                 = local.tags
#   create_eip           = false
# }

# module "k8s_master1" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-k8s-master1-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "orchestration"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/kubernetes-new.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "k8s_master2" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-k8s-master2-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "orchestration"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/kubernetes-new.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_k8s_cluster" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-cluster-tg-${var.infra_env}"
#   tg_port = 6443
#   tg_protocol = "HTTPS"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/"
#   host_based_priority = 9
#   host_based_url = "k8s.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "k8s"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_k8s_master1_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-master1-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 19
#   host_based_url = "k8s-master1-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "k8s-master1-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_k8s_master2_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-master2-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 20
#   host_based_url = "k8s-master2-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "k8s-master2-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "k8s_master1_ne" {
#   target_group_arn = module.elb_tg_k8s_master1_ne.target_group_arn
#   target_id        = module.k8s_master1.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "k8s_master1" {
#   target_group_arn = module.elb_tg_k8s_cluster.target_group_arn
#   target_id        = module.k8s_master1.instance_id
#   port             = 6443
# }
# resource "aws_lb_target_group_attachment" "k8s_master2_ne" {
#   target_group_arn = module.elb_tg_k8s_master2_ne.target_group_arn
#   target_id        = module.k8s_master2.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "k8s_master2" {
#   target_group_arn = module.elb_tg_k8s_cluster.target_group_arn
#   target_id        = module.k8s_master2.instance_id
#   port             = 6443
# }

# module "k8s_worker1" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-k8s-worker1-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "orchestration"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/kubernetes-new.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "k8s_worker2" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-k8s-worker2-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "orchestration"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/kubernetes-new.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_k8s_ingress" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-ingress-tg-${var.infra_env}"
#   tg_port = 30000 #change this
#   tg_protocol = "HTTPS"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/"
#   host_based_priority = 10
#   host_based_url = "kubernetes.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "kubernetes"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_k8s_worker1_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-worker1-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 21
#   host_based_url = "k8s-worker1-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "k8s-worker1-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_k8s_worker2_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-k8s-worker2-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 22
#   host_based_url = "k8s-worker2-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "k8s-worker2-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "k8s_worker1_ne" {
#   target_group_arn = module.elb_tg_k8s_worker1_ne.target_group_arn
#   target_id        = module.k8s_worker1.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "k8s_worker1" {
#   target_group_arn = module.elb_tg_k8s_ingress.target_group_arn
#   target_id        = module.k8s_worker1.instance_id
#   port             = 30000 #change this
# }
# resource "aws_lb_target_group_attachment" "k8s_worker2_ne" {
#   target_group_arn = module.elb_tg_k8s_worker2_ne.target_group_arn
#   target_id        = module.k8s_worker2.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "k8s_worker2" {
#   target_group_arn = module.elb_tg_k8s_ingress.target_group_arn
#   target_id        = module.k8s_worker2.instance_id
#   port             = 30000 #change this
# }