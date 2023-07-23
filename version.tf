terraform {
  # backend "s3" {
  #   bucket         = "test-terraform-s3-backend"
  #   key            = "test-project"
  #   region         = "ap-southeast-1"
  #   encrypt        = true
  #   role_arn       = "arn:aws:iam::331040559991:role/HpiS3BackendRole"
  #   dynamodb_table = "terraform-series-s3-backend"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
