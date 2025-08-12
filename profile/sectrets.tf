resource "random_password" "password" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.profile.metadata[0].name
  }

  data = {
    password = random_password.password.result
  }
}