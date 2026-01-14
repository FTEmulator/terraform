resource "kubernetes_service" "api" {
    metadata {
        name = "api-service"
        namespace = kubernetes_namespace.api.metadata[0].name
    }

    spec {
        selector = {
            app = "api"
        }
        port {
            port = var.api_port
            target_port = var.api_port
            node_port = var.api_port
        }
        type = "NodePort"
    }
}