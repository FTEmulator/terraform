# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Pagina web
module "website" {
  source = "./website"
}

## Flux
resource "kubernetes_manifest" "gitRepository" {
  manifest = yamldecode(file("${path.module}/website/flux/gitRepository.yaml"))
}

resource "kubernetes_manifest" "kustomization" {
  manifest = yamldecode(file("${path.module}/website/flux/kustomization.yaml"))
}