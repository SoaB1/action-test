terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.21.1"
    }
  }

  cloud {
    organization = "Masaya-Network"

    workspaces {
      name = "action-test"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailscale_tailnet
}
