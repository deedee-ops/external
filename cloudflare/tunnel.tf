resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = var.account_id
  name       = "homelab tunnel"
  tunnel_secret = var.tunnel_secret
  config_src = "local"
}
