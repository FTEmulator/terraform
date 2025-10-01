resource "kubernetes_namespace" "api" {
    metadata {
        name = var.api_namespace
    }
}