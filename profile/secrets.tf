resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.profile.metadata[0].name
  }

  data = {
    username = random_string.user.result
    password = random_password.password.result
  }
}
