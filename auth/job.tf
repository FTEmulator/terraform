resource "kubernetes_job" "auth-downloader" {
    metadata {
        name = "auth-downloader"
        namespace = kubernetes_namespace.auth.metadata[0].name
    }

    spec {
        template {
            metadata {}

            spec {
                restart_policy = "Never"

                container {
                    name = "auth-downloader"
                    image = "gradle:${var.nodeVersion}"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        mkdir - p /app /mnt/auth
                        cd /app
                        git clone ${var.git_repo} .
                        chmod +x gradlew
                        ./gradlew bootJar
                        cp -r ./build/libs/*.jar /mnt/auth/app.jar
                        chmod +x /mnt/auth/app.jar
                        echo "La api se descargo correctamente"
                    EOF
                    ]

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

        backoff_limit = 4
    }

    wait_for_completion = true

    timeouts {
        create = "5m"
    }
}