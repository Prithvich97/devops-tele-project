variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
}

variable "cluster_version" {
    description = "Version of the EKS cluster"
    type        = string
  
}

variable "vpc_id" {
    description = "ID of the VPC where the EKS cluster will be created"
    type        = string
  
}

variable "subnet_ids" {
    description = "List of subnets IDs for the EKS cluster"
    type        = list(string)
}

variable "node_group_name" {
    description = "Name of the EKS node group"
    type        = map(object({
        name = string
        instance_type = string
        capacity_type = string
        scaling_config = object({
            desired_size = number
            max_size     = number
            min_size     = number
        })
    }))
}



    