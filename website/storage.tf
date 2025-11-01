# Persistent volume
resource "kubernetes_persistent_volume" "website_pv" {
  metadata {
    name = "nginx-pv"
  }
  spec {
    capacity  = {
      storage = var.website_pv_storage
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = "/mnt/website"
      }
    }
    persistent_volume_reclaim_policy = "Delete"
    storage_class_name = "local-path"
  }
}

# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "website_pvc" {
  metadata {
    name = "nginx-pvc"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.website_pv_storage
      }
    }
    volume_name = kubernetes_persistent_volume.website_pv.metadata[0].name
    storage_class_name  = "local-path"
  }
}