module "prometheus" {
  source = "./modules/ec2"
  name                      = "prometheus-${var.infra_env}"
  infra_env                 = var.infra_env
  infra_role                = "monitoring"
  instance_ami              = data.aws_ami.amzn2.id
  instance_size             = "t2.micro"
  ssh_key                   = "dansweet"
  user_data                 = file("./scripts/prometheus.sh")
  instance_root_device_size = 30
  subnets                   = data.aws_subnets.private_subnets.ids
  security_groups           = [data.aws_security_group.private_sg.id]
  tags = local.tags
  create_eip = false
}
resource "aws_lb_target_group" "prometheus" {
  name     = "tcit-prometheus-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.myvpc.id
  health_check {
    interval=10
    path="/status"
  }
}

# module "grafana" {
#   source = "./modules/ec2"
#   name                      = "grafana-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "monitoring"
#   instance_ami              = data.aws_ami.ubuntu.id
#   instance_size             = "t2.micro"
#   ssh_key                   = "dansweet"
#   user_data                 = file("./scripts/grafana.sh")
#   instance_root_device_size = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# resource "aws_lb_target_group" "grafana" {
#   name     = "tcit-grafana-tg"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.myvpc.id
#   health_check {
#     interval=10
#     path="/api/health"
#   }
# }

# module "sonarqube" {
#   source = "./modules/ec2"
#   name                      = "sonarqube-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "codetesting"
#   instance_ami              = data.aws_ami.ubuntu.id
#   instance_size             = "t3.medium"
#   ssh_key                   = "dansweet"
#   user_data                 = file("./scripts/sonarqube.sh")
#   instance_root_device_size = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# resource "aws_lb_target_group" "sonarqube" {
#   name     = "tcit-sonarqube-tg"
#   port     = 9000
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.myvpc.id
#   health_check {
#     interval=10
#     path="/api/system/status"
#   }
# }

# module "nexus" {
#   source = "./modules/ec2"
#   name                      = "nexus-${var.infra_env}"
#   infra_env                 = var.infra_env
#   infra_role                = "imagerepo"
#   instance_ami              = data.aws_ami.amzn2.id
#   instance_size             = "t3.medium"
#   ssh_key                   = "dansweet"
#   user_data                 = file("./scripts/nexus.sh")
#   instance_root_device_size = 30
#   subnets                   = data.aws_subnets.private_subnets.ids
#   security_groups           = [data.aws_security_group.private_sg.id]
#   tags = local.tags
#   create_eip = false
# }
# resource "aws_lb_target_group" "nexus" {
#   name     = "tcit-nexus-tg"
#   port     = 8081
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.myvpc.id
#   health_check {
#     interval=10
#     path="/service/rest/v1/status"
#   }
# }
