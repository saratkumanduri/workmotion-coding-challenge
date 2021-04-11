locals  {
	private_subnet_names = formatlist("${var.account_prefix}-${var.environment}-private-subnet-%s",var.azs)
	public_subnet_names = formatlist("${var.account_prefix}-${var.environment}-public-subnet-%s",var.azs)
}


data "aws_vpcs" "vpcs" {
	tags = var.vpc_tags
}

#our subnet ids in  vpc
data "aws_subnet_ids" "subnet_ids"{
	vpc_id = sort(data.aws_vpcs.vpcs.ids)[0]
}

#our subnets
data "aws_subnet" "subnets" {
    for_each = data.aws_subnet_ids.subnet_ids.ids
    id = each.value
}

#our private subnets
data "aws_subnet" "private_subnets" {
	count = length(local.private_subnet_names)
	vpc_id = sort(data.aws_vpcs.vpcs.ids)[0]

	filter {
		name = "tag:Name"
		values = [local.private_subnet_names[count.index]]
	}
}

#our private subnets
data "aws_subnet" "public_subnets" {
	count = length(local.public_subnet_names)
	vpc_id = sort(data.aws_vpcs.vpcs.ids)[0]

	filter {
		name = "tag:Name"
		values = [local.public_subnet_names[count.index]]
	}
}

data "aws_availability_zones" "azs" {
  state = "available"
}
