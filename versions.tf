terraform {
  required_version = ">= 1.0.11"

  required_providers {
    aws    = "~= 4.8.0"
    archive = "~= 2.4.0"
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}