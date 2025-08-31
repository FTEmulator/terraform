# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Pagina web
module "website" {
  source = "./website"
}

## Flux - WEBSITE
resource "kubernetes_manifest" "website_gitRepository" {
  manifest = yamldecode(file("${path.module}/website/flux/gitRepository.yaml"))
  depends_on = [module.website]  # Esperar a que el módulo website termine
}

resource "kubernetes_manifest" "website_kustomization" {
  manifest = yamldecode(file("${path.module}/website/flux/kustomization.yaml"))
  depends_on = [module.website, kubernetes_manifest.website_gitRepository]  # Esperar al módulo y al GitRepository
}

# Api
module "api" {
  source = "./api"
}

## Flux - API
resource "kubernetes_manifest" "api_gitRepository" {
  manifest = yamldecode(file("${path.module}/api/flux/gitRepository.yaml"))
  depends_on = [module.api]  # Esperar a que el módulo api termine
}

resource "kubernetes_manifest" "api_kustomization" {
  manifest = yamldecode(file("${path.module}/api/flux/kustomization.yaml"))
  depends_on = [module.api, kubernetes_manifest.api_gitRepository]  # Esperar al módulo y al GitRepository
}

# Auth
module "auth" {
  source = "./auth"
}

## Flux - AUTH
resource "kubernetes_manifest" "auth_gitRepository" {
  manifest = yamldecode(file("${path.module}/auth/flux/gitRepository.yaml"))
  depends_on = [module.auth]  # Esperar a que el módulo auth termine
}

resource "kubernetes_manifest" "auth_kustomization" {
  manifest = yamldecode(file("${path.module}/auth/flux/kustomization.yaml"))
  depends_on = [module.auth, kubernetes_manifest.auth_gitRepository]  # Esperar al módulo y al GitRepository
}

# Profile
module "profile" {
  source = "./profile"
}

## Flux - PROFILE
resource "kubernetes_manifest" "profile_gitRepository" {
  manifest = yamldecode(file("${path.module}/profile/flux/gitRepository.yaml"))
  depends_on = [module.profile]  # Esperar a que el módulo profile termine
}

resource "kubernetes_manifest" "profile_kustomization" {
  manifest = yamldecode(file("${path.module}/profile/flux/kustomization.yaml"))
  depends_on = [module.profile, kubernetes_manifest.profile_gitRepository]  # Esperar al módulo y al GitRepository
}