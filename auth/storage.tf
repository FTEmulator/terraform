# Persistent volume

resource "kubernetes_persistent_volume" "auth_pv" {
    metadata {
        name = "auth-pv"
    }

    spec {
        capacity = {
            storage = var.auth_api_pv_storage
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
            host_path {
                path = "/mnt/auth"
            }
        }

        persistent_volume_reclaim_policy = "Delete"
        storage_class_name = "local-path"
    }
}

# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "auth_pvc" {
    metadata {
        name = "auth-pvc"
        namespace = kubernetes_namespace.auth.metadata[0].name
    }

    spec {
        access_modes = ["ReadWriteMany"]
        resources {
            requests = {
                storage = var.auth_api_pv_storage
            }
        }

        volume_name = kubernetes_persistent_volume.auth_pv.metadata[0].name
        storage_class_name = "local-path"
    }
}
