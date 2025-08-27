resource "kubernetes_deployment" "profile" {
    metadata {
        name = "profile"
        namespace = kubernetes_namespace.profile.metadata[0].name
        labels = {
            app = "profile"
        }
    }

    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "profile"
            }
        }

        template {
            metadata {
                labels = {
                    app = "profile"
                }
            }

            spec {
                init_container {
                    name = "wait-jar"
                    image = "busybox"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        while [ ! -f /mnt/profile/app.jar ]; do
                            echo "Esperando el jar de profile..."
                            sleep 5
                        done
                    EOF
                    ]

                    volume_mount {
                        mount_path = "/mnt/profile"
                        name = "profile-storage"
                    }
                }

                container {
                    name = "profile"
                    image = var.deployVersion
                    command = ["java", "-jar", "/mnt/profile/app.jar"]
                
                    port  {
                        container_port = var.jdk_port
                    }

                    env {
                        name = "POSTGRES_USER"
                        value = "profile_user"
                    }

                    # env {
                    #     name = "POSTGRES_PASSWORD"
                    #     value_from {
                    #         secret_key_ref {
                    #         name = kubernetes_secret.postgres_credentials.metadata[0].name
                    #         key  = "password"
                    #         }
                    #     }
                    # }

                    env {
                        name  = "POSTGRES_PASSWORD"
                        value = "Almi123"
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
                        mount_path = "/mnt/profile"
                        name = "profile-storage"
                    }
                }

                volume {
                    name = "profile-storage"
                    persistent_volume_claim {
                        claim_name = kubernetes_persistent_volume_claim.profile_pvc.metadata[0].name
                    }
                }
            }
        }
    }
}
