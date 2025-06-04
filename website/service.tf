resource "kubernetes_namespace" "website" {
  metadata {
    name = "website"
  }
}

# Servicio
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
    namespace = kubernetes_namespace.website.metadata[0].name
  }
  spec {
    selector = {
      App = "nginx"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = var.node_port
    }
    type = "NodePort"
  }
}