resource "cloudflare_dns_record" "aliases_verify" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "@"
  content = "hosted-email-verify=${var.domain_aliases[each.value.name].verification_code}"
  type    = "TXT"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_mx_primary" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id  = each.value.zone_id
  name     = "@"
  content  = "aspmx1.migadu.com"
  type     = "MX"
  priority = "10"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_mx_secondary" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id  = each.value.zone_id
  name     = "@"
  content  = "aspmx2.migadu.com"
  type     = "MX"
  priority = "20"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_mx_dkim_a" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "key1._domainkey"
  content = "key1.${each.value.name}._domainkey.migadu.com."
  proxied = false
  type    = "CNAME"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_mx_dkim_b" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "key2._domainkey"
  content = "key2.${each.value.name}._domainkey.migadu.com."
  proxied = false
  type    = "CNAME"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_mx_dkim_c" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "key3._domainkey"
  content = "key3.${each.value.name}._domainkey.migadu.com."
  proxied = false
  type    = "CNAME"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_spf" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "@"
  content = "v=spf1 include:spf.migadu.com -all"
  type    = "TXT"
  ttl = 1
}

resource "cloudflare_dns_record" "aliases_dmarc" {
  for_each = data.cloudflare_zone.domain_aliases

  zone_id = each.value.zone_id
  name    = "_dmarc"
  content = "v=DMARC1; p=quarantine;"
  type    = "TXT"
  ttl = 1
}
