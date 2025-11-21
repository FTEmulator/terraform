# Servicio
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = var.website_port
      target_port = var.website_port
    }
    type = "ClusterIP"
  }
}