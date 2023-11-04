module "prod" {
    source = "../../infra"

    cargo_IAM = "producao"
    ambiente = "producao"
}

output "IP_alb" {
  value = module.prod.IP
}

terraform {
 backend "remote" {
    organization = "fiap-postech-groupo7"
    hostname = "app.terraform.io"

 workspaces {
      prefix = "terraform-actions"
    }
}
}
