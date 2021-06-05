# terraform {
#   backend "s3" {
#     bucket  = "dev-tfstate"
#     key     = "ecr/terraform.tfstate"
#     region  = "us-east-1"
#     profile = "sample-dev"
#   }
# }