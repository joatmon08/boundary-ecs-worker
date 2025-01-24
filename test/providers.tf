terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.102"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "hcp" {}