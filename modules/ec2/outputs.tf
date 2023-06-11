output "instance_eip" {
  value = aws_eip.eip-1.*.public_ip
}

output "instance_id" {
  value = module.ec2_instance.id
}

output "private_ip" {
  value = module.ec2_instance.private_ip
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
