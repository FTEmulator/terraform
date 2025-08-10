#  Persistent volume
resource "kubernetes_persistent_volume" "profile_pv" {
    metadata {
        name = "profile-pv"
    }

    spec {
        capacity = {
            storage = "1Gi"
        }

        access_modes = ["ReadWriteMany"]

        persistent_volume_source {
            host_path {
                path = "/mnt/profile"
            }
        }

        persistent_volume_reclaim_policy = "Delete"
        storage_class_name = "manual"
    }
}

resource "kubernetes_persistent_volume" "postgres_pv" {
    metadata {
        name = "postgres-pv"
    }

    spec {
        capacity = {
            storage = "1Gi"
        }

        access_modes = ["ReadWriteMany"]

        persistent_volume_source {
            host_path {
                path = "/mnt/postgres"
            }
        }

        persistent_volume_reclaim_policy = "Delete"
        storage_class_name = "manual"
    }
}

# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "profile_pvc" {
    metadata {
        name = "profile-pvc"
        namespace = kubernetes_namespace.profile.metadata[0].name
    }

    spec {
        access_modes = ["ReadWriteMany"]
        resources {
            requests = {
                storage = "1Gi"
            }
        }

        volume_name = kubernetes_persistent_volume.profile_pv.metadata[0].name
        storage_class_name = "manual"
    }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
    metadata {
        name = "postgres-pvc"
        namespace = kubernetes_namespace.profile.metadata[0].name
    }

    spec {
        access_modes = ["ReadWriteMany"]
        resources {
            requests = {
                storage = "1Gi"
            }
        }

        volume_name = kubernetes_persistent_volume.postgres_pv.metadata[0].name
        storage_class_name = "manual"
    }
}