terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }

    migadu = {
      source  = "metio/migadu"
      version = "2025.5.22"
    }
  }

  required_version = ">= 1.6.0"
}

data "cloudflare_zone" "domain_primary" {
  zone_id = var.domain_primary.zone_id
}

data "cloudflare_zone" "domain_spam" {
  zone_id = var.domain_spam.zone_id
}

data "cloudflare_zone" "domain_aliases" {
  for_each = var.domain_aliases

  zone_id = each.value.zone_id
}
