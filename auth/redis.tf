resource "kubernetes_deployment" "redis" {
    metadata {
        name = "redis"
        namespace = kubernetes_namespace.auth.metadata[0].name
        labels = {
            app = "redis"
        }
    }

    spec {
        replicas = 1

        selector {
            match_labels = {
                app = "redis"
            }
        }

        template {
            metadata {
                labels = {
                    app = "redis"
                }
            }
            spec {
                container {
                    name = "redis"
                    image = "redis:8.0.2-alpine"
                    port {
                        container_port = 6379
                    }
                }
            }
        }
        
    }
}