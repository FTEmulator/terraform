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