resource "kubernetes_namespace" "profile" {
    metadata {
        name = "profile"
    }
}