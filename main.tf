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
}

resource "kubernetes_manifest" "website_kustomization" {
  manifest = yamldecode(file("${path.module}/website/flux/kustomization.yaml"))
}

# Api
module "api" {
  source = "./api"
}

## Flux
resource "kubernetes_manifest" "api_gitRepository" {
  manifest = yamldecode(file("${path.module}/api/flux/gitRepository.yaml"))
}

resource "kubernetes_manifest" "api_kustomization" {
  manifest = yamldecode(file("${path.module}/api/flux/kustomization.yaml"))
}

# Auth
module "auth" {
  source = "./auth"
}

## Flux
resource "kubernetes_manifest" "auth_gitRepository" {
  manifest = yamldecode(file("${path.module}/auth/flux/gitRepository.yaml"))
}

resource "kubernetes_manifest" "auth_kustomization" {
  manifest = yamldecode(file("${path.module}/auth/flux/kustomization.yaml"))
}

# Profile
module "profile" {
  source = "./profile"
}

## Flux
resource "kubernetes_manifest" "profile_gitRepository" {
  manifest = yamldecode(file("${path.module}/profile/flux/gitRepository.yaml"))
}

resource "kubernetes_manifest" "profile_kustomization" {
  manifest = yamldecode(file("${path.module}/profile/flux/kustomization.yaml"))
}