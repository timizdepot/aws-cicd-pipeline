resource "aws_lb_target_group" "target_group" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  health_check {
    interval=10
    path=var.health_check_path
  }
}
resource "aws_lb_listener_rule" "host_based" {
  listener_arn = var.listener_arn
  priority     = var.host_based_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  condition {
    host_header {
      values = [var.host_based_url]
    }
  }
  # condition {
  #   path_pattern {
  #     values = [var.path_pattern]
  #   }
  # }
}
resource "aws_route53_record" "other" {
  zone_id = var.route53_zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}