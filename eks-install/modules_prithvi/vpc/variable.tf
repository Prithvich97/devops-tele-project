variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    
  
}

variable "availability_zones" {
    description = "List of availability zones for the VPC"
    type        = list(string)
  
}

variable "private_subnets_cidr" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
  
}

variable "public_subnets_cidr" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
  
}

variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
  
}
