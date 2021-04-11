bucket  = "workmotion-terraform-state"
key     = "core/terraform.tfstate"
region  = "eu-central-1"
encrypt = true
dynamodb_table = "workmotion-terraform-lock"