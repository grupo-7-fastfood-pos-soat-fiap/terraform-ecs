terraform {
  backend "s3" {
    bucket = "terraform-state-fiap-postech-grupo7"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
