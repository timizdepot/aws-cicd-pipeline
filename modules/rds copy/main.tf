resource "aws_db_parameter_group" "db_pg" {
  name   = "${var.infra_env}-pg-aurora"
  family = "aurora-mysql5.7"
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name        = "${var.infra_env} RDS Parameter Group-Aurora"
    Project     = "timizus.com"
    Type        = "aurora"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_rds_cluster_parameter_group" "cpg" {
  name   = "${var.infra_env}-pg-aurora-cluster"
  family = "aurora-mysql5.7"
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
  }
  tags = {
    Name        = "${var.infra_env} RDS Parameter Group-Aurora"
    Project     = "timizus.com"
    Type        = "aurora"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}


resource "aws_rds_cluster" "aurora" {

  name           = "${var.infra_env}-aurora-mysql-cluster"
  engine         = "aurora-mysql"
  engine_version = "5.7.12"

  instances = {
    1 = {
      instance_class      = var.instance_type
      publicly_accessible = false
    }
    2 = {
      identifier     = "mysql-static-1"
      instance_class = var.instance_type
    }
    # 3 = {
    #   identifier     = "mysql-excluded-1"
    #   instance_class = var.instance_type
    #   #promotion_tier = 15
    # }
  }
  vpc_id        = var.vpc_id
  
  master_username                 = var.master_username
  master_password                 = var.master_password
  db_parameter_group_name         = aws_db_parameter_group.db_pg.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cpg.name
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    Name        = "${var.infra_env}-rds-mysql-cluster"
    Project     = "timizus.com"
    Type        = "aurora"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}