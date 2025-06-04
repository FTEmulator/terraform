# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

module "website" {
  source = "./website"
}