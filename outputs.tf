output "k8s_ingress" {
  value = kubernetes_ingress.kubeingress.status
}