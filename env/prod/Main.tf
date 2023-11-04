module "prod" {
    source = "../../infra"

    cargo_IAM = "producao"
    ambiente = "producao"
}

output "IP_alb" {
  value = module.prod.IP
}
