# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Website
## Despliege del servicio
module "website" {
  source = "./website"
}

## Actualizedor del repositorio
resource "kubernetes_manifest" "trigger" {
  manifest = yamldecode(file("${path.module}/website/trigger.yaml"))
}

resource "kubernetes_manifest" "gitrepo" {
  manifest = yamldecode(file("${path.module}/website/gitrepo.yaml"))
}

resource "kubernetes_manifest" "action" {
  manifest = yamldecode(templatefile(
    "${path.module}/website/gitEventRunner/action.yaml.tmpl",
    {
      repo_url = "https://github.com/FTEmulator/website.git"
    }
  ))
}