resource "azurerm_resource_group" "rg" {
  name     = "azure-crc"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "kubecluster" {
  name                = "azure-crc"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "imkumpy"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}
