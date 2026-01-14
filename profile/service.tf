# Profile api service
resource "kubernetes_service" "profile" {
    metadata {
        name = "profile-service"
        namespace = kubernetes_namespace.profile.metadata[0].name
    }

    spec {
        selector = {
            app = "profile"
        }

        port {
            port = var.profile_api_port
            target_port = var.profile_api_port
            node_port = 30003
        }

        type = "NodePort"
    }
}

# Profile postgres service
resource "kubernetes_service" "postgres" {
    metadata {
        name = "postgres-service"
        namespace = kubernetes_namespace.profile.metadata[0].name
    }

    spec {
        selector = {
            app = "postgres"
        }

        port {
            port = var.profile_postgres_port
            target_port = var.profile_postgres_port
        }

        type = "ClusterIP"
    }
}