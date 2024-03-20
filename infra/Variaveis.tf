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
  default = "hackathon"
}

variable "tg_name" {
  default = "application-lb-target-group"
}
