terraform {
  required_version = ">= 1.0.11"

  required_providers {
    aws    = ">= 4.8.0"
    archive = ">= 2.4.0"
  }
}

provider "aws" {}