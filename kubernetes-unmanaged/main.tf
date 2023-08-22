# Declare the AWS provider configuration
provider "aws" {
  # Specify the AWS region using a variable
  region = var.k8-region
}

