data "azurerm_key_vault" "imkumpykeyvault" {
  name                = "imkumpy-com"
  resource_group_name = "imkumpy.com"
}

data "azurerm_key_vault_secret" "namecheapsecret" {
  name         = "namecheap-api-token"
  key_vault_id = data.azurerm_key_vault.imkumpykeyvault.id
}