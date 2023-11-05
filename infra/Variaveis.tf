variable "cargo_IAM" {
  type = string
}

variable "ambiente" {
  type = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "alb_name" {
  default = "alb"
}

variable "tg_name" {
  default = "target-group"
}

# rds
variable "rds_db_name" {
  description = "RDS database name"
  default     = "mydb"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "foo"
}
variable "rds_password" {
  description = "RDS database password"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t2.micro"
}
