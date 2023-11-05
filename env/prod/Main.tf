module "prod" {
  source = "../../infra"

  cargo_IAM    = "prod"
  ambiente     = "prod"
  rds_db_name  = "postgres"
  rds_username = "postgres"
  rds_password = "#F1apFastF00d"
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
