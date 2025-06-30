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
            port = var.jdk_port
            target_port = var.jdk_port
        }

        type = "ClusterIP"
    }
}

# Profile postgres service