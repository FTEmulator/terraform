resource "kubernetes_job" "profile-downloader" {
    metadata {
        name = "profile-downloader"
        namespace = kubernetes_namespace.profile.metadata[0].name
    }

    spec {
        template {
            metadata {}

            spec {
                restart_policy = "Never"

                container {
                    name = "profile-downloader"
                    image = "gradle:${var.jdkVersion}"
                    command = ["sh", "-c"]
                    args = [<<EOF
                        mkdir -p /app /mnt/profile
                        cd /app
                        git clone ${var.git_repo} .
                        chmod +x gradlew
                        ./gradlew bootJar
                        cp -r ./build/libs/*.jar /mnt/profile/app.jar
                        chmod +x /mnt/profile/app.jar
                        echo "La api se descargo correctamente"
                    EOF
                    ]

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

        backoff_limit = 4
    }
    
    wait_for_completion = true

    timeouts {
        create = "20m"
    }
}