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
            port = var.auth_api_port
            target_port = var.auth_api_port
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
            port = var.auth_redis_port
            target_port = var.auth_redis_port
        }

        type = "ClusterIP"
    }
}