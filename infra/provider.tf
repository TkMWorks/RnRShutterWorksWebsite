terraform {
  required_version = ">= 1.0.0"
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-state-bucket-075925653666"
    key          = "RNRShutterWorksWebsite/TerraformState.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::075925653666:role/TerraformAutomationIAMRole"
  }
}

provider "archive" {}