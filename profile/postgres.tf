resource "kubernetes_deployment" "postgres" {
    metadata {
        name      = "postgres"
        namespace = kubernetes_namespace.profile.metadata[0].name
        labels = {
            app = "postgres"
        }
    }

    spec {
        replicas = 1

        selector {
            match_labels = {
                app = "postgres"
            }
        }

        template {
            metadata {
                labels = {
                    app = "postgres"
                }
            }

            spec {
                container {
                    name  = "postgres"
                    image = var.profile_postgres_image

                    port {
                        container_port = 5432
                    }

                    env {
                        name  = "POSTGRES_DB"
                        value = "profile"
                    }

                    env {
                        name  = "POSTGRES_USER"
                        value = var.profile_postgres_user
                    }

                    env {
                        name = "POSTGRES_PASSWORD"

                        value_from {
                            secret_key_ref {
                            name = kubernetes_secret.postgres_credentials.metadata[0].name
                            key  = "password"
                            }
                        }
                    }

                    env {
                        name  = "PGDATA"
                        value = "/var/lib/postgresql/data/pgdata"
                    }

                    readiness_probe {
                        exec {
                            command = ["pg_isready", "-U", "postgres", "-d", "postgres"]
                        }
                        initial_delay_seconds = 5
                        period_seconds        = 5
                        timeout_seconds       = 3
                        failure_threshold     = 3
                    }

                    liveness_probe {
                        exec {
                            command = ["pg_isready", "-U", "postgres", "-d", "postgres"]
                        }
                        initial_delay_seconds = 30
                        period_seconds        = 10
                        timeout_seconds       = 5
                        failure_threshold     = 3
                    }

                    volume_mount {
                        name       = "postgres-storage"
                        mount_path = "/var/lib/postgresql/data"
                    }

                    resources {
                        requests = {
                            memory = var.profile_postgres_memory
                            cpu    = var.profile_postgres_cpu
                        }
                        limits = {
                            memory = var.profile_postgres_memory
                            cpu    = var.profile_postgres_cpu
                        }
                    }
                }

                volume {
                    name = "postgres-storage"
                    persistent_volume_claim {
                        claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
                    }
                }

                restart_policy = "Always"
            }
        }
    }
}
