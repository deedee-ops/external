resource "cloudflare_ruleset" "external_ingress" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_firewall_custom"
  zone_id = data.cloudflare_zone.base_domain.zone_id

  rules =[ {
    action = "skip"
    action_parameters = {
  ruleset = "current"
}
    description = "Allow access to kromgo API for shields.io"
    enabled     = true
    expression  = "(http.host eq \"kromgo.${var.base_domain.name}\" and ip.geoip.asnum in {30081 54825})"

    logging = {
  enabled = true
}
  },
    {
    action = "skip"
    action_parameters = {
  ruleset = "current"
}
    description = "Allow access to ArgoCD webhook for GitHub"
    enabled     = true
    expression  = "(http.host eq \"argocd.${var.base_domain.name}\") and (ip.geoip.asnum eq 36459) and (http.request.uri.path eq \"/api/webhook\")"

    logging = {
  enabled = true
}
    },
    {
    action = "skip"
    action_parameters = {
  ruleset = "current"
}
    description = "Allow access to external services"
    enabled     = true
    expression  = "(http.host eq \"share.${var.base_domain.name}\" and (not starts_with(http.request.uri.path, \"/admin\"))) and (ip.geoip.country in {\"PL\"} and (not cf.client.bot) and (cf.threat_score lt 15))"

    logging = {
  enabled = true
}
    },
    {
    action      = "block"
    description = "Block everything else"
    enabled     = true
    expression  = "true"
    }]



}
