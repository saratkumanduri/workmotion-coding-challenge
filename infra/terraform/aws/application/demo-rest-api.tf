module "demoapp" {
  source = "./demorestapi"
  account_prefix = var.account_prefix
  default_tags = var.tags
  environment = var.environment
  region = var.region
  vpc_azs = var.vpc_availability_zones
  vpc_endpoint_access_cidrs = var.vpc_endpoint_access_cidrs
  vpc_tags = var.vpc_tags
}