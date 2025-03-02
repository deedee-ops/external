# Cloudflare Tunnel Ingress
resource "cloudflare_record" "external_ingress" {
  zone_id = data.cloudflare_zone.base_domain.id
  name    = "external"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

# rustdesk relay
resource "cloudflare_record" "rustdesk_relay" {
  zone_id = data.cloudflare_zone.base_domain.id
  name    = "relay"
  content = "homelab.${data.cloudflare_zone.base_domain.name}"
  type    = "CNAME"
  proxied = false
  ttl     = 1
}
