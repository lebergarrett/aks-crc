resource "azurerm_resource_group" "resource_group" {
  name     = "azure-crc"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "azure-crc"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
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

data "kubectl_file_documents" "namespace" {
  content = file("${path.root}/manifests/argocd/namespace.yaml")
}

data "kubectl_file_documents" "argocd" {
  content = file("${path.root}/manifests/argocd/install.yaml")
}

resource "kubectl_manifest" "namespace" {
  count              = length(data.kubectl_file_documents.namespace.documents)
  yaml_body          = element(data.kubectl_file_documents.namespace.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
  depends_on = [
    kubectl_manifest.namespace,
  ]
  count              = length(data.kubectl_file_documents.argocd.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"
}

data "kubectl_file_documents" "crc" {
  content = file("${path.root}/manifests/argocd/crc.yaml")
}

resource "kubectl_manifest" "my-nginx-app" {
  depends_on = [
    kubectl_manifest.argocd,
  ]
  count              = length(data.kubectl_file_documents.crc.documents)
  yaml_body          = element(data.kubectl_file_documents.crc.documents, count.index)
  override_namespace = "argocd"
}