# public sg
resource "aws_security_group" "public" {
  name        = "${var.infra_env}-public-sg"
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
    { "Name" = "${var.infra_env}-public-sg" },
    { "Role" = "public" },
    local.tags
  )
}

# bastion sg
resource "aws_security_group" "bastion" {
  name        = "${var.infra_env}-bastion-sg"
  description = "Bastion host access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.163.242.10/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.infra_env}-bastion-sg" },
    { "Role" = "bastion" },
    local.tags
  )
}

# private sg
resource "aws_security_group" "private" {
  name        = "${var.infra_env}-private-sg"
  description = "Private internal access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.public.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { "Name" = "${var.infra_env}-private-sg" },
    { "Role" = "private" },
    local.tags
  )
}

# database sg
resource "aws_security_group" "database" {
  name        = "${var.infra_env}-database-sg"
  description = "Database access"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.private.id]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.private.id]
  }
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    security_groups = [aws_security_group.private.id]
  }
  tags = merge(
    { "Name" = "${var.infra_env}-database-sg" },
    { "Role" = "database" },
    local.tags
  )
}
