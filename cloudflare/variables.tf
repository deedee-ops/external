variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "base_domain" {
  description = "Domain used for all homelab needs"
  type        = object({ name = string, zone_id = string })
  sensitive   = true
}

variable "tunnel_secret" {
  description = "Cloudflare tunnel secret (at least 32 bytes, base64 encoded)"
  type        = string
  sensitive   = true
}
