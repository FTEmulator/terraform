resource "kubernetes_job" "api-downloader" {
    metadata {
        name = "api-downloader"
        namespace = kubernetes_namespace.api.metadata[0].name
    }

    spec {
        template {
            metadata {}

            spec {
                restart_policy = "Never"

                container {
                    name = "api-downloader"
                    image = "gradle:${var.nodeVersion}"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        mkdir -p /app /mnt/api
                        cd /app
                        git clone ${var.git_repo} .
                        chmod +x gradlew
                        ./gradlew bootJar
                        cp -r ./build/libs/*.jar /mnt/api/app.jar
                        chmod +x /mnt/api/app.jar
                        echo "La api se descargo correctamente"
                    EOF
                    ]

                    volume_mount {
                        mount_path = "/mnt/api"
                        name = "api-storage"
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

        backoff_limit = 4
    }

    wait_for_completion = true

    timeouts {
        create = "20m"
    }
}