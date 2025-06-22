// Auth api service
resource "kubernetes_service" "auth" {
    metadata {
        name = "auth-service"
        namespace = kubernetes_namespace.auth.metadata[0].name
    }

    spec {
        selector = {
            app = "auth"
        }

        port {
            port = var.node_port
            target_port = var.node_port
        }

        type = "ClusterIP"
    }
}

// Auth redis service
resource "kubernetes_service" "redis" {
    metadata {
        name = "redis-service"
        namespace = kubernetes_namespace.auth.metadata[0].name
    }

    spec {
        selector = {
            app = "redis"
        }

        port {
            port = var.redis_port
            target_port = var.redis_port
        }

        type = "ClusterIP"
    }
}