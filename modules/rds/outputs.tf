output "app_eip" {
  value = aws_eip.eip-1.*.public_ip
}

output "instance_id" {
  value = module.ec2_instance.id
}

