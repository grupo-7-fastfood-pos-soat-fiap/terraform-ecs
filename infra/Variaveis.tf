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
variable "rds_username" {
  description = "RDS database username"
  default     = "foo"
}
variable "rds_password" {
  description = "RDS database password"
}
