resource "kubernetes_deployment" "auth" {
    metadata {
        name = "auth"
        namespace = kubernetes_namespace.auth.metadata[0].name
        labels = {
            app = "auth"
        }
    }

    depends_on = [
        kubernetes_job.auth-downloader
    ]

    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "auth"
            }
        }

        template {
            metadata {
                labels = {
                    app = "auth"
                }
            }
            
            spec {
                init_container {
                    name = "wait-jar"
                    image = "busybox"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        while [ ! -f /mnt/auth/app.jar ]; do
                            echo "Esperando el jar de auth..."
                            sleep 5
                        done
                    EOF
                    ]

                    volume_mount {
                        mount_path = "/mnt/auth"
                        name = "auth-storage"
                    }
                }

                container {
                    name = "auth"
                    image = var.auth_api_image
                    command = ["java", "-jar", "/mnt/auth/app.jar"]

                    port {
                        container_port = var.auth_api_port
                    }

                    resources {
                        limits = {
                            cpu    = var.auth_api_cpu
                            memory = var.auth_api_memory
                        }
                        requests = {
                            cpu    = var.auth_api_cpu
                            memory = var.auth_api_memory
                        }
                    }

                    env {
                        name  = "REDIS_HOST"
                        value = "redis-service"
                    }

                    env {
                        name  = "REDIS_PORT"
                        value = var.auth_redis_port
                    }

                    env {
                        name = "REDIS_PASSWORD"
                        value_from {
                            secret_key_ref {
                            name = kubernetes_secret.redis_credentials.metadata[0].name
                            key  = "password"
                            }
                        }
                    }

                    volume_mount {
                        mount_path = "/mnt/auth"
                        name = "auth-storage"
                    }
                }

                volume {
                    name = "auth-storage"
                    persistent_volume_claim {
                        claim_name = kubernetes_persistent_volume_claim.auth_pvc.metadata[0].name
                    }
                }
            }
        }
    }
}