variable "base_domain" {
  description = "Domain used for all homelab needs"
  type        = object({ name = string, zone_id = string })
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_secret" {
  description = "Cloudflare tunnel secret (at least 32 bytes, base64 encoded)"
  type        = string
  sensitive   = true
}

variable "mail_migadu_admin_username" {
  description = "Administrative email for Migadu"
  type        = string
  sensitive   = true
}

variable "mail_migadu_admin_token" {
  description = "Migadu API Token"
  type        = string
  sensitive   = true
}

variable "mail_domain_primary" {
  description = "Primary domain for email"
  type        = object({ name = string, zone_id = string, verification_code = string })
  sensitive   = true
}

variable "mail_domain_spam" {
  description = "Spam domain for email"
  type        = object({ name = string, zone_id = string })
  sensitive   = true
}

variable "mail_domain_aliases" {
  description = "List of aliases for primary domain"
  type        = map(object({ zone_id = string, verification_code = string }))
}

variable "mail_extra_identities" {
  description = "List of extra identities allowed to send and receive"
  type = map(object({
    name                    = string,
    password                = optional(string),
    may_receive             = optional(bool),
    may_send                = optional(bool),
    may_access_imap         = optional(bool),
    may_access_manage_sieve = optional(bool),
    may_access_pop3         = optional(bool)
  }))
}

variable "mail_password_primary" {
  description = "Password for primary account"
  type        = string
  sensitive   = true
}

variable "mail_sender_name" {
  description = "Sender name for email"
  type        = string
}

variable "mail_spam_senders" {
  description = "List of spammers to reject"
  type        = list(string)
}

variable "mail_spam_targets" {
  description = "List of personal emails user by spammers to reject"
  type        = list(string)
}

variable "state_and_plan_passphrase" {
  description = "Passphrase to decrypt state and plan"
  type        = string
  sensitive   = true
}
