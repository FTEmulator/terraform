# Deploy
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }

    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:${var.nginx_version}"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.2"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

# Servicio
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.metadata[0].labels.App
    }
    port {
      port = 80
      target_port = 80
      node_port = var.node_port
    }
    type = "NodePort"
  }
}