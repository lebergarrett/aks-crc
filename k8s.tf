resource "kubernetes_deployment" "kubedeployment" {
  metadata {
    name = "azure-crc"
    labels = {
      app = "azure-crc-nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "azure-crc-nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "azure-crc-nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "crc-nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          volume_mount {
            name       = "nginx-volume"
            mount_path = "/usr/share/nginx/html/"
          }
        }
        volume {
          name = "nginx-volume"
          config_map {
            name = "nginx-configmap"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "nginxconfigmap" {
  metadata {
    name = "nginx-configmap"
  }
  data = {
    "index.html" = file("${path.root}/nginx/html/index.html")
    "counter.js" = file("${path.root}/nginx/html/counter.js")
  }

  binary_data = {
    "avatar.jpg" = filebase64("${path.root}/nginx/html/avatar.jpg")
  }
}

resource "kubernetes_service" "kubeservice" {
  metadata {
    name = "crc-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.kubedeployment.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress" "kubeingress" {
  wait_for_load_balancer = true
  metadata {
    name = "crc-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                     = "addon-http-application-routing"
      "service.beta.kubernetes.io/azure-dns-label-name" = "imkumpy"
    }
    labels = {
      app = "azure-crc-nginx"
    }
  }
  spec {
    backend {
      service_name = kubernetes_service.kubeservice.metadata.0.name
      service_port = 80
    }
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.kubeservice.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}
