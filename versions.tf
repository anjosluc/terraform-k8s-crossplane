terraform {
  required_providers {
    helm = ">= 2.3.0"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.59.0"
    }
  }
}