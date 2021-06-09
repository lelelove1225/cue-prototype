terraform {
  required_version = "0.14.8"

  required_providers {
    aws = "3.32.0"
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region  = var.aws_region
}