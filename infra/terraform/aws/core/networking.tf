module "vpc" {
  source             = "../modules/vpc"
  account_prefix     = var.account_prefix
  environment        = var.environment
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  region             = var.region
}