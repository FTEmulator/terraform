# Namespace
variable "website_namespace" {
  description = "Website namespace"
  type        = string
  default     = "website"
  
}

# Ports
variable "website_port" {
  description = "Website port"
  type        = number
  default     = 80
}

variable "website_internal_port" {
  description = "Container port"
  type        = number
  default     = 80
}

# Website
variable "website_image" {
  description = "Versión de Nginx a utilizar"
  type        = string
  default     = "nginx:latest"
}

variable "website_git_repo" {
  description = "Repositorio de github"
  type = string
  default = "https://github.com/FTEmulator/website.git"
}

variable "website_cpu" {
    description = "API CPU"
    type        = string
    default     = "500m"
}

variable "website_memory" {
    description = "API Memory"
    type        = string
    default     = "512Mi"
}

variable "website_pv_storage" {
    description = "Persistent Volume Storage"
    type        = string
    default     = "1Gi"
}

# Job
variable "job_image" {
  description = "Puerto NodePort para exponer el servicio de Nginx"
  type        = string
  default     = "node:latest"
}

variable "api_url" {
  description = "URL de la API para NEXT_PUBLIC_API_URL"
  type        = string
  default = "http://localhost:30080"
}