resource "aws_db_instance" "postgres" {
  allocated_storage    = 5
  storage_type         = "gp2"
  instance_class       = "db.t2.micro"
  identifier           = "postgres"
  engine               = "postgres"
  engine_version       = "12.10"
  parameter_group_name = "default.postgres12"
 
  db_name  = "postgres"
  username = var.rds_username
  password = var.rds_password
 
  vpc_security_group_ids = [aws_security_group.postgres.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}
