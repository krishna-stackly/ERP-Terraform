terraform {

  required_version = ">= 1.8.0"

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 6.0"
    }
  }

  backend "s3" {

    bucket = "terraform-backend-state-ecs"

    key = "projects/{{var.project_name}}/{{var.environment}}/terraform.tfstate"

    region = "us-east-1"

    encrypt = true

    use_lockfile = true
  }
}


provider "aws" {

  region = var.aws_region

  default_tags {

    tags = {

      ManagedBy = "Terraform"
    }
  }
}