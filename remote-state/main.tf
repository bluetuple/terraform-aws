

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "<your-bucket-name>"
    key    = "terraformstate/<your-stage (dev/tst/prd/sbx)>/state"
    region = "<your-region>"

    dynamodb_table = "<your dynamodb-table>"
    encrypt        = true
  }

}

provider "aws" {
  region = var.sbx_region

}
