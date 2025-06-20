resource "kubernetes_role" "restart_deployment" {
  metadata {
    name      = "restart-deployment"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "patch"]
  }
}

resource "kubernetes_role_binding" "restart_deployment" {
  metadata {
    name      = "restart-deployment"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.restart_deployment.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
}