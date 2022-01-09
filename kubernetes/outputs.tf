output "k8s_ingress" {
  value = kubernetes_ingress.nginx_ingress.status
}