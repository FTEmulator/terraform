resource "kubernetes_namespace" "auth" {
    metadata {
        name = var.auth_namespace
    }
}