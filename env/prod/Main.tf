module "prod" {
  source = "../../infra"

  cargo_IAM = "prod"
  ambiente  = "prod"
}

terraform {
  backend "remote" {
    organization = "fiap-postech-groupo7"
    hostname     = "app.terraform.io"

    workspaces {
      prefix = "hackathon"
    }
  }
}
