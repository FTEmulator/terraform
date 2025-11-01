resource "random_password" "password" {
  length  = 16
  special = true
}

resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

resource "kubernetes_secret" "auth_jwt_secret" {
  metadata {
    name      = "auth-jwt-secret"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  data = {
    jwt_secret = random_password.jwt_secret.result
  }
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