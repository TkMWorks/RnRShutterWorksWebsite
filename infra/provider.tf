terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
  }
  backend "s3" {
    bucket  = "tkm-tfstate"
    key     = "RNRShutterWorksWebsite/infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

provider "archive" {

}