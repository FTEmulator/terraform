# Persistent volume
resource "kubernetes_persistent_volume" "api_pv" {
    metadata {
        name = "api-pv"
    }
    spec {
        capacity = {
            storage = var.api_pv
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
            host_path {
                path = "/mnt/api"
            }
        }
        persistent_volume_reclaim_policy = "Delete"
        storage_class_name = "local-path"
    }
}

# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "api_pvc" {
    metadata {
        name = "api-pvc"
        namespace = kubernetes_namespace.api.metadata[0].name
    }

    spec {
        access_modes = ["ReadWriteMany"]
        resources {
            requests = {
                storage = var.api_pv
            }
        }
        volume_name = kubernetes_persistent_volume.api_pv.metadata[0].name
        storage_class_name = "local-path"
    }
}