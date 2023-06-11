# public sg
resource "aws_security_group" "public" {
  name        = "${var.project}-public-sg-${var.infra_env}"
  description = "Public internet access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-public-sg-${var.infra_env}" },
    { "Role" = "public" },
    var.tags
  )
}

# loadbalancer sg
resource "aws_security_group" "loadbalancer" {
  name        = "${var.project}-loadbalancer-sg-${var.infra_env}"
  description = "Application Load Balancer public internet access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-loadbalancer-sg-${var.infra_env}" },
    { "Role" = "loadbalancer" },
    var.tags
  )
}

# bastion sg
resource "aws_security_group" "bastion" {
  name        = "${var.project}-bastion-sg-${var.infra_env}"
  description = "Bastion host access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-bastion-sg-${var.infra_env}" },
    { "Role" = "bastion" },
    var.tags
  )
}

# private sg
resource "aws_security_group" "private" {
  name        = "${var.project}-private-sg-${var.infra_env}"
  description = "Private internal access"
  vpc_id      = module.vpc.vpc_id
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.bastion.id]
  # }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-private-sg-${var.infra_env}" },
    { "Role" = "private" },
    var.tags
  )
}

# database sg
resource "aws_security_group" "database" {
  name        = "${var.project}-database-sg-${var.infra_env}"
  description = "Database access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    { "Name" = "${var.project}-database-sg-${var.infra_env}" },
    { "Role" = "database" },
    var.tags
  )
}

# k8s master sg
resource "aws_security_group" "k8s_master" {
  name        = "${var.project}-k8s-master-sg-${var.infra_env}"
  description = "k8s master access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    description = "Kubernetes API server"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2379
    to_port     = 2380
    description = "etcd server client API"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 10250
    to_port     = 10250
    description = "Kubernetes API server"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 10257
    to_port     = 10257
    description = "kube-controller-manager"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 10259
    to_port     = 10259
    description = "kube-scheduler"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-k8s-master-sg-${var.infra_env}" },
    { "Role" = "k8s-master" },
    var.tags
  )
}

# k8s worker sg
resource "aws_security_group" "k8s_worker" {
  name        = "${var.project}-k8s-worker-sg-${var.infra_env}"
  description = "k8s worker access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    description = "NodePort Services"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10250
    to_port     = 10250
    description = "Kubernetes API server"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.project}-k8s-worker-sg-${var.infra_env}" },
    { "Role" = "k8s-worker" },
    var.tags
  )
}