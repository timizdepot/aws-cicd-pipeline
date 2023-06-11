output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "elb_name" {
  value = aws_lb.elb.name
}

output "elb_dns_name" {
  value = aws_lb.elb.dns_name
}

output "elb_zone_id" {
  value = aws_lb.elb.zone_id
}
