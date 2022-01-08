output "client_certificate" {
  value = azurerm_kubernetes_cluster.kubecluster.kube_config.0.client_certificate
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.kubecluster.kube_config_raw
  sensitive = true
}

output "k8s_service" {
  value = kubernetes_service.kubeservice.status
}