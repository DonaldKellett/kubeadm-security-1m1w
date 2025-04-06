terraform {
  required_providers {
    aws = {
      source  = "opentofu/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "opentofu/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "local" {}
