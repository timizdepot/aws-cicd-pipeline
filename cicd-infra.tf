
# module "prometheus" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-prometheus-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "monitoring"
#   instance_ami              = data.aws_ami.amzn2.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t2.micro"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/prometheus.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_prometheus" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-prometheus-tg-${var.infra_env}"
#   tg_port = 9090
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/status"
#   host_based_priority = 2
#   host_based_url = "prometheus.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "prometheus"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_prometheus_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-prometheus-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 12
#   host_based_url = "prometheus-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "prometheus-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "prometheus_ne" {
#   target_group_arn = module.elb_tg_prometheus_ne.target_group_arn
#   target_id        = module.prometheus.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "prometheus" {
#   target_group_arn = module.elb_tg_prometheus.target_group_arn
#   target_id        = module.prometheus.instance_id
#   port             = 9090
# }

# module "grafana" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-grafana-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "monitoring"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t2.micro"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/grafana.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_grafana" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-grafana-tg-${var.infra_env}"
#   tg_port = 3000
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/api/health"
#   host_based_priority = 3
#   host_based_url = "grafana.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "grafana"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_grafana_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-grafana-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 13
#   host_based_url = "grafana-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "grafana-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "grafana_ne" {
#   target_group_arn = module.elb_tg_grafana_ne.target_group_arn
#   target_id        = module.grafana.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "grafana" {
#   target_group_arn = module.elb_tg_grafana.target_group_arn
#   target_id        = module.grafana.instance_id
#   port             = 3000
# }

# module "sonarqube" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-sonarqube-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "codetesting"
#   instance_ami              = data.aws_ami.ubuntu.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/sonarqube.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_sonarqube" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-sonarqube-tg-${var.infra_env}"
#   tg_port = 9000
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/api/system/status"
#   host_based_priority = 4
#   host_based_url = "sonarqube.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "sonarqube"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_sonarqube_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-sonarqube-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 14
#   host_based_url = "sonarqube-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "sonarqube-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "sonarqube_ne" {
#   target_group_arn = module.elb_tg_sonarqube_ne.target_group_arn
#   target_id        = module.sonarqube.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "sonarqube" {
#   target_group_arn = module.elb_tg_sonarqube.target_group_arn
#   target_id        = module.sonarqube.instance_id
#   port             = 9000
# }

# module "nexus" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-nexus-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "imagerepo"
#   instance_ami              = data.aws_ami.amzn2.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t3.medium"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/nexus.sh")
#   root_device_size          = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_nexus" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-nexus-tg-${var.infra_env}"
#   tg_port = 8081
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/service/rest/v1/status"
#   host_based_priority = 5
#   host_based_url = "nexus.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "nexus"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_nexus_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-nexus-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 15
#   host_based_url = "nexus-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "nexus-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "nexus_ne" {
#   target_group_arn = module.elb_tg_nexus_ne.target_group_arn
#   target_id        = module.nexus.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "nexus" {
#   target_group_arn = module.elb_tg_nexus.target_group_arn
#   target_id        = module.nexus.instance_id
#   port             = 8081
# }

# module "deployment_dev" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-deployment-dev"
#   infra_env                 = "dev"
#   infra_role                = "devserver"
#   instance_ami              = data.aws_ami.amzn2.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t2.micro"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/deployment-servers.sh")
#   root_device_size          = 10
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_deployment_dev" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-tg-dev"
#   tg_port = 8080
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/"
#   host_based_priority = 6
#   host_based_url = "dev.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "dev"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_deployment_dev_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-ne-tg-${var.infra_env}"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 16
#   host_based_url = "dev-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "dev-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "deployment_dev_ne" {
#   target_group_arn = module.elb_tg_deployment_dev_ne.target_group_arn
#   target_id        = module.deployment_dev.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "deployment_dev" {
#   target_group_arn = module.elb_tg_deployment_dev.target_group_arn
#   target_id        = module.deployment_dev.instance_id
#   port             = 8080
# }

# module "deployment_stage" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-deployment-stage"
#   infra_env                 = "stage"
#   infra_role                = "stageserver"
#   instance_ami              = data.aws_ami.amzn2.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t2.micro"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/deployment-servers.sh")
#   root_device_size          = 10
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_deployment_stage" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-tg-stage"
#   tg_port = 8080
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/"
#   host_based_priority = 7
#   host_based_url = "stage.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "stage"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_deployment_stage_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-ne-tg-stage"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 17
#   host_based_url = "stage-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "stage-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "deployment_stage_ne" {
#   target_group_arn = module.elb_tg_deployment_stage_ne.target_group_arn
#   target_id        = module.deployment_stage.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "deployment_stage" {
#   target_group_arn = module.elb_tg_deployment_stage.target_group_arn
#   target_id        = module.deployment_stage.instance_id
#   port             = 8080
# }
# module "deployment_prod" {
#   source = "./modules/ec2"
#   name                      = "${local.tags.project}-deployment-prod"
#   infra_env                 = "prod"
#   infra_role                = "prodserver"
#   instance_ami              = data.aws_ami.amzn2.id
#   iam_instance_profile      = data.aws_iam_instance_profile.logs.name
#   instance_size             = "t2.micro"
#   ssh_key                   = "ohio"
#   user_data                 = file("./scripts/deployment-servers.sh")
#   root_device_size          = 10
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# module "elb_tg_deployment_prod" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-tg-prod"
#   tg_port = 8080
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.https_listener.arn
#   health_check_path = "/"
#   host_based_priority = 8
#   host_based_url = "prod.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "prod"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# module "elb_tg_deployment_prod_ne" {
#   source = "./modules/elb_tg"
#   tg_name = "${local.tags.project}-deployment-ne-tg-prod"
#   tg_port = 9100
#   tg_protocol = "HTTP"
#   vpc_id = data.aws_vpc.myvpc.id
#   listener_arn = data.aws_lb_listener.http_listener.arn
#   health_check_path = "/"
#   host_based_priority = 18
#   host_based_url = "prod-ne.${data.aws_route53_zone.domain.name}"
#   domain_name = data.aws_route53_zone.domain.name
#   route53_zone_id = data.aws_route53_zone.domain.zone_id
#   subdomain = "prod-ne"
#   elb_dns_name = data.aws_lb.elb.dns_name
#   elb_zone_id = data.aws_lb.elb.zone_id
# }
# resource "aws_lb_target_group_attachment" "deployment_prod_ne" {
#   target_group_arn = module.elb_tg_deployment_prod_ne.target_group_arn
#   target_id        = module.deployment_prod.instance_id
#   port             = 9100
# }
# resource "aws_lb_target_group_attachment" "deployment_prod" {
#   target_group_arn = module.elb_tg_deployment_prod.target_group_arn
#   target_id        = module.deployment_prod.instance_id
#   port             = 8080
# }
