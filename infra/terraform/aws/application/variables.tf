variable "account_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "vpc_availability_zones" {
  description = "List of availability zones"
  type = list(string)
}

variable "region" {
  default = "eu-central-1"
}

variable "tags" {
  type = map(string)
  default = {
    "billing" = "APPS"
  }
}

variable "vpc_endpoint_access_cidrs" {}

variable "vpc_tags" {}