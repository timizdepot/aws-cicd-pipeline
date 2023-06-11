output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "database_subnets" {
  value = module.vpc.database_subnets
}
output "public_sg" {
  value = aws_security_group.public
}
output "private_sg" {
  value = aws_security_group.private
}
output "k8s_master_sg" {
  value = aws_security_group.k8s_master
}
output "k8s_worker_sg" {
  value = aws_security_group.k8s_worker
}
output "loadbalancer_sg" {
  value = aws_security_group.loadbalancer
}
output "database_sg" {
  value = aws_security_group.database
}
output "bastion_sg" {
  value = aws_security_group.bastion
}