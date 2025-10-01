resource "kubernetes_namespace" "website" {
  metadata {
    name = var.website_namespace
  }
}