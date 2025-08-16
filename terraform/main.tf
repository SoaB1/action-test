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

module "aws" {
  source = "./modules/aws"

  ansible_webhook       = var.ansible_webhook
  tailscale_tailnet_key = module.tailscale.tailnet_key

  depends_on = [module.tailscale.tailnet_key]
}

module "tailscale" {
  source = "./modules/tailscale"

  tailscale_api_key   = var.tailscale_api_key
  tailscale_tailnet   = var.tailscale_tailnet
  aws_ec2_server_name = var.aws_ec2_server_name
  aws_ec2_is_running  = module.aws.is_running
}
