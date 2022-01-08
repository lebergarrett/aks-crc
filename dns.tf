data "azurerm_key_vault" "imkumpykeyvault" {
  name                = "imkumpy-com"
  resource_group_name = "imkumpy.com"
}

resource "azurerm_dns_zone" "imkumpydns" {
  name                = "imkumpy.com"
  resource_group_name = data.azurerm_key_vault.imkumpykeyvault.resource_group_name
}

data "azurerm_key_vault_secret" "namecheapsecret" {
  name         = "namecheap-api-token"
  key_vault_id = data.azurerm_key_vault.imkumpykeyvault.id
}

resource "namecheap_domain_dns" "namecheapdns" {
  domain      = azurerm_dns_zone.imkumpydns.name
  nameservers = azurerm_dns_zone.imkumpydns.name_servers
}

resource "azurerm_dns_a_record" "imkumpy" {
  name                = "@"
  zone_name           = azurerm_dns_zone.imkumpydns.name
  resource_group_name = azurerm_dns_zone.imkumpydns.resource_group_name
  ttl                 = 300
  records             = [kubernetes_ingress.kubeingress.status[0].load_balancer[0].ingress[0].ip]
}