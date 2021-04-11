bucket  = "workmotion-terraform-state"
key     = "application/terraform.tfstate"
region  = "eu-central-1"
encrypt = true
dynamodb_table = "workmotion-terraform-lock"