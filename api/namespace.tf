resource "kubernetes_namespace" "api" {
    metadata {
        name = "api"
    }
}