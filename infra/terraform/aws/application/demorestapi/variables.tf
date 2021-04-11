variable "region" {}

variable "default_tags" {}

variable "vpc_azs" {
  type = list(string)
}

variable "account_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "vpc_endpoint_access_cidrs" {}

variable "vpc_tags" {}

