terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3"
    }

  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-3"
  default_tags {
    tags = {
      env     = var.environment
      Owner   = "devops"
      Project = var.project
    }
  }
}
