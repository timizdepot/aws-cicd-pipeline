resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = var.name
  ami                    = var.instance_ami
  instance_type          = var.instance_size
  subnet_id              = random_shuffle.subnets.result[0]
  vpc_security_group_ids = var.security_groups
  key_name               = var.ssh_key
  user_data              = var.user_data
  monitoring             = false
  iam_instance_profile   = var.iam_instance_profile

  #create_before_destroy = true

  root_block_device = [{
    volume_size = var.root_device_size
    volume_type = "gp2"
  }]
  tags = merge({
    Role        = var.infra_role
    Environment = var.infra_env
    },
    var.tags
  )
}


resource "aws_eip" "eip-1" {
  count = (var.create_eip) ? 1 : 0
  vpc   = true
  lifecycle {
    prevent_destroy = false
  }
  tags = merge({
    Environment = var.infra_env
  },
  var.tags
  ) 
}
# ideal use to avoid destroying eips
resource "aws_eip_association" "eip_assoc" {
  count         = (var.create_eip) ? 1 : 0
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.eip-1[0].id
}