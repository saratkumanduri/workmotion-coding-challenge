terraform {
  required_version = "~>0.13.1"
}

provider "aws" {
  version = "~> 3.1"
  region  = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "workmotion-terraform-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

##################################################################################
# REMOTE TERRAFORM STATE LOCKING
##################################################################################
resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "workmotion-terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}