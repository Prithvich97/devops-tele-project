resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.cluster_name}-vpc"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    }
}

resource "aws_subnet" "private" {
    count                   = length(var.private_subnets_cidr)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.private_subnets_cidr[count.index]
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.cluster_name}-private-${count.index}"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_subnet" "public" {
    count                   = length(var.public_subnets_cidr)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnets_cidr[count.index]
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.cluster_name}-public-${count.index}"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/elb" = 1
    
  }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.cluster_name}-igw"
    
  
}
}
resource "aws_eip" "nat" {
  count = length(var.public_subnets_cidr)
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
    count        = length(var.public_subnets_cidr)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id    = aws_subnet.public[count.index].id
    tags = {
        Name = "${var.cluster_name}-nat-${count.index}"
    }

}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.cluster_name}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
    count          = length(var.public_subnets_cidr)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
    count  = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id

    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

    tags = {
        Name = "${var.cluster_name}-private-rt${count.index + 1}"
    }
}

resource "aws_route_table_association" "private" {
    count          = length(var.private_subnets_cidr)
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

