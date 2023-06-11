output "app_eip" {
  value = aws_eip.eip-1.*.public_ip
}

output "app_instance" {
  value = module.ec2_instance.id
}

