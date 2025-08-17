# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Pagina web
module "website" {
  source = "./website"
}

## Flux
resource "kubernetes_manifest" "website_gitRepository" {
  manifest = yamldecode(file("${path.module}/website/flux/gitRepository.yaml"))
  # depends_on = [kubernetes_namespace.website]
}

resource "kubernetes_manifest" "website_kustomization" {
  manifest = yamldecode(file("${path.module}/website/flux/kustomization.yaml"))
  # depends_on = [kubernetes_namespace.website]
}

# Api
module "api" {
  source = "./api"
}

## Flux
resource "kubernetes_manifest" "api_gitRepository" {
  manifest = yamldecode(file("${path.module}/api/flux/gitRepository.yaml"))
  # depends_on = [kubernetes_namespace.api]
}

resource "kubernetes_manifest" "api_kustomization" {
  manifest = yamldecode(file("${path.module}/api/flux/kustomization.yaml"))
  # depends_on = [kubernetes_namespace.api]
}

# Auth
module "auth" {
  source = "./auth"
}

## Flux
resource "kubernetes_manifest" "auth_gitRepository" {
  manifest = yamldecode(file("${path.module}/auth/flux/gitRepository.yaml"))
  # depends_on = [kubernetes_namespace.auth]
}

resource "kubernetes_manifest" "auth_kustomization" {
  manifest = yamldecode(file("${path.module}/auth/flux/kustomization.yaml"))
  # depends_on = [kubernetes_namespace.auth]
}

# Profile
module "profile" {
  source = "./profile"
}

## Flux
resource "kubernetes_manifest" "profile_gitRepository" {
  manifest = yamldecode(file("${path.module}/profile/flux/gitRepository.yaml"))
  # depends_on = [kubernetes_namespace.profile]
}

resource "kubernetes_manifest" "profile_kustomization" {
  manifest = yamldecode(file("${path.module}/profile/flux/kustomization.yaml"))
  # depends_on = [kubernetes_namespace.profile]
}