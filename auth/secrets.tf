resource "random_password" "password" {
  length  = 16
  special = true
}

resource "kubernetes_secret" "redis_credentials" {
  metadata {
    name      = "redis-credentials"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  data = {
    password = random_password.password.result
  }
}