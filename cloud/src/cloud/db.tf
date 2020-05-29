resource "aws_db_subnet_group" "appdbsubnetgroup" {
  name       = "app-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_parameter_group" "pgparamsloadtest" {
  name   = "pgparamsloadtest"
  family = "postgres9.6"
  parameter {
    name = "max_connections"
    # default value of var.db_max_connections = 300
    value        = var.db_max_connections
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "appdb" {
  db_subnet_group_name = aws_db_subnet_group.appdbsubnetgroup.name
  allocated_storage    = 5
  storage_type         = "gp2"
  instance_class       = var.app_db_instance_class
  name                 = var.app_db_name

  identifier = var.app_db_instance_identifier

  parameter_group_name = aws_db_parameter_group.pgparamsloadtest.name
  engine               = "postgres"
  engine_version       = "9.6.9"
  storage_encrypted    = false

  username = var.app_db_user
  password = var.app_db_password
  port     = "5432"

  vpc_security_group_ids = [
    # allow from default sg 
    # TODO: TEST_FOR_REMOVE
    data.aws_security_group.default.id,
    # allow anyone in explicit allow (default subnet)
    aws_security_group.allow_db.id,
    # TODO: TEST_FOR_REMOVE
    # allow outbound (updates etc -- not strictly necessary but havent checked)
    aws_security_group.allow_all_outbound.id
  ]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
}


