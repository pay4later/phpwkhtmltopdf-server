provider "aws" {
  region  = "${var.region}"
  version = "~> 1.34"
}

terraform {
  backend "s3" {
    key            = "pdf_renderer.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
  }
}

data "aws_caller_identity" "current" {}
