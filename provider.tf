terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.kubecluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.kubecluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.kubecluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.kubecluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.kubecluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubecluster.kube_config.0.cluster_ca_certificate)
}