resource "kubernetes_namespace" "profile" {
    metadata {
        name = var.profile_namespace
    }
}