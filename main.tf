terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  encryption {
    key_provider "pbkdf2" "state_and_plan" {
      passphrase = var.state_and_plan_passphrase
    }

    method "aes_gcm" "state_and_plan" {
      keys = key_provider.pbkdf2.state_and_plan
    }

    state {
      enforced = false

      method   = method.aes_gcm.state_and_plan
    }

    plan {
      enforced = true
      method   = method.aes_gcm.state_and_plan
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }

    migadu = {
      source  = "metio/migadu"
      version = "2025.5.29"
    }
  }

  required_version = ">= 1.6.0"
}

module "cloudflare" {
  account_id    = var.cloudflare_account_id
  base_domain   = var.base_domain
  tunnel_secret = var.cloudflare_tunnel_secret

  source = "./cloudflare"
  providers = {
    cloudflare = cloudflare
  }
}

module "mail" {
  domain_primary   = var.mail_domain_primary
  domain_spam      = var.mail_domain_spam
  domain_aliases   = var.mail_domain_aliases
  extra_identities = var.mail_extra_identities
  password_primary = var.mail_password_primary
  sender_name      = var.mail_sender_name
  spam_senders     = var.mail_spam_senders
  spam_targets     = var.mail_spam_targets

  source = "./mail"
  providers = {
    cloudflare = cloudflare
    migadu     = migadu
  }
}
