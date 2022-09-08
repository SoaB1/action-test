terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.16.0"
    }
  }
}

variable "email" {
  type      = string
  sensitive = true
}

variable "api_key" {
  type      = string
  sensitive = true
}

variable "cloudflare_domain" {
  type      = string
  sensitive = true
}

variable "zone_id" {
  type      = string
  sensitive = true
}

provider "cloudflare" {
  email   = var.email
  api_key = var.api_key
}

data "cloudflare_access_identity_provider" "test_data" {
  zone_id = var.zone_id
  name    = "MasayaNetwork"
}

resource "cloudflare_access_application" "test_network" {
  zone_id          = var.zone_id
  name             = "Test Network"
  domain           = "*.test-aaa.${var.cloudflare_domain}"
  type             = "self_hosted"
  session_duration = "24h"
}
