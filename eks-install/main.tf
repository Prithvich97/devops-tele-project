terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-tf-state-bucket-prithvi"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-EKS-SATE-LOCK"
    
  }
}


provider "aws" {
  region = "us-east-2"
  
}

module "vpc" {
  source = "./modules_prithvi/vpc"
  vpc_cidr =  var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr = var.public_subnets_cidr
  cluster_name = var.cluster_name
}


module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets_ids
  node_groups     = var.node_groups
}