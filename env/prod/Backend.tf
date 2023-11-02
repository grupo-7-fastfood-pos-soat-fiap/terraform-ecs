terraform {
  backend "s3" {
    bucket = "terraform-state-postech-grupo7"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}
