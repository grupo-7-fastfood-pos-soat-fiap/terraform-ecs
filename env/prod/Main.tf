module "prod" {
  source = "../../infra"

  cargo_IAM = "prod"
  ambiente  = "prod"
  rds_db_name = "db_name"
  rds_username = "username"
  rds_password = "password"
}

terraform {
  backend "remote" {
    organization = "fiap-postech-groupo7"
    hostname     = "app.terraform.io"

    workspaces {
      prefix = "terraform-actions"
    }
  }
}
