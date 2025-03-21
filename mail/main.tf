terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.52.0"
    }

    migadu = {
      source  = "metio/migadu"
      version = "2025.3.13"
    }
  }

  required_version = ">= 1.6.0"
}

data "cloudflare_zone" "domain_primary" {
  name = var.domain_primary.name
}

data "cloudflare_zone" "domain_spam" {
  name = var.domain_spam.name
}

data "cloudflare_zone" "domain_aliases" {
  for_each = var.domain_aliases

  name = each.key
}
