terraform {
  backend "s3" {
    bucket = "terraform-state-fiap-postech-grupo7"
    key    = "Prod/terraform.tfstate"
    region = "us-west-2"
  }
}
