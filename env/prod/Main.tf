module "prod" {
    source = "../../infra"

    nome_repositorio = "prod"
    cargo_IAM = "producao"
    ambiente = "producao"
}

output "IP_alb" {
  value = module.prod.IP
}
