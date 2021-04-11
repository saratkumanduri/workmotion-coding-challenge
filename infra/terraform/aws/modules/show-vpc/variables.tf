variable "azs" {
  type = list(string)
}

variable "account_prefix" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "vpc_tags" {}
