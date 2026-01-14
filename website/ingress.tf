resource "kubernetes_ingress_v1" "website" {
  metadata {
    name      = "website-ingress"
    namespace = kubernetes_namespace.website.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      "traefik.ingress.kubernetes.io/router.priority"    = "1"
    }
  }

  spec {
    rule {
      host = "website.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
              port {
                number = var.website_port
              }
            }
          }
        }
      }
    }
  }
}
