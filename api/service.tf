resource "kubernetes_service" "api" {
    metadata {
        name = "api-service"
        namespace = kubernetes_namespace.api.metadata[0].name
    }

    spec {
        selector = {
            App = "api"
        }
        port {
            port = 8080
            target_port = 8080
            node_port = var.node_port
        }
        type = "NodePort"
    }
}