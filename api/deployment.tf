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
                    image = var.api_image
                    command = ["java", "-jar", "/mnt/api/app.jar"]
                
                    env {
                        name = "SERVER_PORT"
                        value = var.api_port    
                    }

                    env {
                        name = "INTERNAL_PORT"
                        value = var.api_internal_port
                    }

                    env {
                        name = "AUTH_SERVICE_HOST"
                        value = var.api_auth_service_host
                    }

                    env {
                        name = "AUTH_SERVICE_PORT"
                        value = var.api_auth_service_port
                    }

                    env {
                        name = "PROFILE_SERVICE_HOST"
                        value = var.api_profile_service_host
                    }

                    env {
                        name = "PROFILE_SERVICE_PORT"
                        value = var.api_profile_service_port
                    }

                    port {
                        container_port = var.api_port
                    }

                    resources {
                        limits = {
                            cpu    = var.api_cpu
                            memory = var.api_memory
                        }
                        requests = {
                            cpu    = var.api_cpu
                            memory = var.api_memory
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