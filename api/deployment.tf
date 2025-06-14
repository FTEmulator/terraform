resource "kubernetes_deployment" "api" {
    metadata {
        name = "api"
        namespace = kubernetes_namespace.api.metadata[0].name
        labels = {
            app = "api"
        }
    }

    depends_on = [
        kubernetes_job.api-downloader
    ]

    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "api"
            }
        }
        template {
            metadata {
                labels = {
                    app = "api"
                }
            }
            spec {
                init_container {
                    name = "wait-jar"
                    image = "busybox"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        while [ ! -f /mnt/api/app.jar ]; do
                            echo "Esperando el jar de la api..."
                            sleep 5
                        done
                    EOF
                    ]

                    volume_mount {
                        mount_path = "/mnt/api"
                        name       = "api-storage"
                    } 
                }
                container {
                    name = "api"
                    image = "eclipse-temurin:21-jdk"
                    command = ["java", "-jar", "/mnt/api/app.jar"]
                
                    env {
                        name = "SERVER_PORT"
                        value = "8080"
                    }

                    port {
                        container_port = 8080
                    }

                    resources {
                        limits = {
                            cpu    = "500m"
                            memory = "512Mi"
                        }
                        requests = {
                            cpu    = "500m"
                            memory = "512Mi"
                        }
                    }

                    volume_mount {
                        mount_path = "/mnt/api"
                        name       = "api-storage"
                    } 
                }

                volume {
                    name = "api-storage"
                    persistent_volume_claim {
                        claim_name = kubernetes_persistent_volume_claim.api_pvc.metadata[0].name
                    }
                }
            }
        }
    }
}