resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.website.metadata[0].name
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = var.website_image

          port {
            container_port = var.website_port
          }

          resources {
            limits = {
              cpu    = var.website_cpu
              memory = var.website_memory
            }
            requests = {
              cpu    = var.website_cpu
              memory = var.website_memory
            }
          }

          volume_mount {
            mount_path = "/usr/share/nginx/html"
            name       = "website-storage"
          }
        }

        volume {
          name = "website-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.website_pvc.metadata[0].name
          }
        }
      }
    }
  }
}
