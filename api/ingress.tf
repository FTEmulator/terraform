resource "kubernetes_ingress_v1" "api" {
  metadata {
    name      = "api-ingress"
    namespace = kubernetes_namespace.api.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      "traefik.ingress.kubernetes.io/router.priority"    = "100"
    }
  }

  spec {
    rule {
      host = "localhost"
      http {
        path {
          path      = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.api.metadata[0].name
              port {
                number = var.api_port
              }
            }
          }
        }
      }
    }
  }
}
