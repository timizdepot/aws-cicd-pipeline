output "ubuntu-ami" {
  value = data.aws_ami.ubuntu.id
}
output "amazon2-ami" {
  value = data.aws_ami.amzn2.id
}
# output "bastion_ip" {
#   value = module.bastion.public_ip
#   # aws ec2 describe-instances --instance-id input_id | findstr "IpAddress"
# }
# output "jenkins_ip" {
#   value = module.jenkins.private_ip
# }
# output "master1_ip" {
#   value = module.k8s_master1.private_ip
# }
# output "master2_ip" {
#   value = module.k8s_master2.private_ip
# }
# output "worker1_ip" {
#   value = module.k8s_worker1.private_ip
# }
# output "worker2_ip" {
#   value = module.k8s_worker2.private_ip
# }