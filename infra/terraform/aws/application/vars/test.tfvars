account_prefix = "workmotion"
environment = "test"
vpc_availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
region = "eu-central-1"
vpc_endpoint_access_cidrs = ["10.7.0.0/16", "10.2.0.0/16", "10.25.12.0/24"]
vpc_tags = {
  "tag:Name" = "workmotion-test-vpc"
}