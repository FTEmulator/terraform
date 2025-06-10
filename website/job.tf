# First deploy
resource "kubernetes_job" "website-downloader" {
  metadata {
    name = "website-downloader"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        restart_policy = "Never"

        container {
          name    = "website-downloader"
          image   = "node:latest"
          command = ["sh", "-c"]
          args = [<<EOF
            mkdir -p /app /mnt/website
            cd /app && git clone ${var.git_repo} .
            npm install
            npx next build
            cp -r out/* /mnt/website
            echo "La pagina se descargo correctamente"
            EOF
          ]
          volume_mount {
            mount_path = "/mnt/website"
            name       = "website-storage"
          }
        }
        volume {
          name = "website-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.website_pvc.metadata[0].name
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
