output "vpc_main_route_table_id" {
  value = element(concat(aws_vpc.main.*.main_route_table_id, list("")), 0)
}

output "vpc_default_route_table_id" {
  value = element(concat(aws_vpc.main.*.default_route_table_id, list("")), 0)
}

output "public_route_table_ids" {
  value = [aws_route_table.public.*.id]
}

output "id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}