resource "kubernetes_namespace" "website" {
  metadata {
    name = "website"
  }
}