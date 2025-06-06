# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Pagina web
module "website" {
  source = "./website"
}