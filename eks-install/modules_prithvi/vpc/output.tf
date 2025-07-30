output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.main.id
}


output "public_subnets_ids" {
    description = "List of IDs for public subnetss"
    value = aws_subnet.public[*].id
}


output "private_subnets_ids" {
    description = "List of IDs for private subnetss"
    value = aws_subnet.private[*].id
}
