terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.2.0"
    }
  }

  required_version = ">= 1.6.0"
}

data "cloudflare_zone" "base_domain" {
  zone_id = var.base_domain.zone_id
}
