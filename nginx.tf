# References
# PV: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume
# PVC: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim
# Job: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job

# Variables
variable "nginx_version" {
  description = "Versión de Nginx a utilizar"
  type        = string
  default     = "latest"
}

variable "node_port" {
  description = "Puerto NodePort para exponer el servicio de Nginx"
  type        = number
  default     = 31234
}

# Namespace
resource "kubernetes_namespace" "website" {
  metadata {
    name = "website"
  }
}

# Persistent volume
resource "kubernetes_persistent_volume" "website_pv" {
  metadata {
    name = "nginx-pv"
  }
  spec {
    capacity  = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/mnt/website"
      }
    }
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name = "manual"
  }
}

# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "website_pvc" {
  metadata {
    name = "nginx-pvc"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.website_pv.metadata[0].name
    storage_class_name  = "manual"
  }
}

# Kubernetes job
resource "kubernetes_job" "website-downloader" {
  metadata {
    name = "website-downloader"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        restart_policy = "Never"

        container {
          name    = "website-downloader"
          image   = "node:latest"
          command = ["sh", "-c"]
          args = [
            "mkdir -p /app /mnt/website && cd /app && git clone https://github.com/FTEmulator/website.git . && npm install && npx next build && cp -r out/* /mnt/website"
          ]
          volume_mount {
            mount_path = "/mnt/website"
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
    backoff_limit = 4
  }
  wait_for_completion = true
}

# Nginx pod
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace.website.metadata[0].name
    labels = {
      App = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        App = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          App = "nginx"
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
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
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

# Servicio
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    selector = {
      App = "nginx"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = var.node_port
    }
    type = "NodePort"
  }
}