resource "azurerm_dns_zone" "imkumpy_dns" {
  name                = "imkumpy.com"
  resource_group_name = data.azurerm_key_vault.imkumpykeyvault.resource_group_name
}

resource "namecheap_domain_dns" "namecheap_dns" {
  domain      = azurerm_dns_zone.imkumpy_dns.name
  nameservers = azurerm_dns_zone.imkumpy_dns.name_servers
}

resource "azurerm_dns_a_record" "imkumpy" {
  name                = "@"
  zone_name           = azurerm_dns_zone.imkumpy_dns.name
  resource_group_name = azurerm_dns_zone.imkumpy_dns.resource_group_name
  ttl                 = 300
  records             = [kubernetes_ingress.nginx_ingress.status[0].load_balancer[0].ingress[0].ip]
}