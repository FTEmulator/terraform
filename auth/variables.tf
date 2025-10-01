# Namespace
variable "auth_namespace" {
  description = "Namespace name"
  type        = string
  default     = "auth"
}

# Ports
variable "auth_api_port" {
    description = "Puerto NodePort para exponer el servicio de la api"
    type        = number
    default     = 30002
}

variable "auth_redis_port" {
  description = "Puerto NodePort para exponer el servicio de redis"
  type        = number
  default     = 6379
}

# Api
variable "auth_git_repo" {
  description = "Repositorio de github"
  type = string
  default = "https://github.com/FTEmulator/auth.git"
}

variable "auth_api_image" {
  description = "Imagen de la api"
  type        = string
  default     = "eclipse-temurin:21-jdk"
}

variable "auth_api_cpu" {
    description = "API CPU"
    type        = string
    default     = "500m"
}

variable "auth_api_memory" {
    description = "API Memory"
    type        = string
    default     = "512Mi"
}

variable "auth_api_pv_storage" {
    description = "Persistent Volume Storage"
    type        = string
    default     = "1Gi"
}

# Redis
variable "auth_redis_image" {
  description = "Imagen de redis"
  type        = string
  default     = "redis:7.2.4-alpine"
}

# Job
variable "auth_job_image" {
  description = "Version de gradle"
  type        = string
  default     = "gradle:8.7.0-jdk21"
}