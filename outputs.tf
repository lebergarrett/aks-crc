output "k8s_service" {
  value = kubernetes_service.kubeservice.status
}