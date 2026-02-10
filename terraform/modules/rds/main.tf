resource "aws_db_subnet_group" "default" {
  name       = "wp-db-subnets"
  subnet_ids = var.subnets

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_instance" "wp" {
  identifier             = "wp-bootcamp-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_pass
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  storage_encrypted      = true 

  lifecycle {
    prevent_destroy = true
  }
}
