output "vpc_id" {
  value = sort(data.aws_vpcs.vpcs.ids)[0]
}
output "private_subnets" {
  value = data.aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = data.aws_subnet.public_subnets.*.id
}

output "private_subnets_cidr_blocks" {
  value = data.aws_subnet.private_subnets.*.cidr_block
}

output "azs" {
  value = var.azs
}