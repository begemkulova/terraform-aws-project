# Output resources
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The ID of the Public Subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "The ID of the Private Subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = aws_nat_gateway.nat.public_ip
}

output "eip_id" {
  description = "The Elastic IP for the NAT gateway"
  value       = aws_eip.nat_eip.id
}

output "public_rt_id" {
  description = "The ID of the Public Route Table"
  value       = aws_route_table.public_route_table.id
}

output "private_rt_id" {
  description = "The ID of the Private Route Table"
  value       = aws_route_table.private_route_table.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.gateway
}
