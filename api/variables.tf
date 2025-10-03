# Namespace
variable "api_namespace" {
  description = "Api namespace"
  type        = string
  default     = "api"
  
}

# Ports
variable "api_port" {
  description = "Api port"
  type        = number
  default     = 8080
}

variable "api_internal_port" {
  description = "Api internal port"
  type        = number
  default     = 30000
}

# Api
variable "api_image" {
  description = "Versión de jdk a utilizar"
  type        = string
  default     = "eclipse-temurin:21-jdk"
}

variable "api_cpu" {
  description = "Api cpu"
  type        = string
  default     = "500m"
}

variable "api_memory" {
  description = "Api memory"
  type        = string
  default     = "512Mi"
  
}

variable "api_pv" {
  description = "Api storage size"
  type        = string
  default     = "1Gi"
  
}

variable "git_repo" {
  description = "Github repository URL"
  type = string
  default = "https://github.com/FTEmulator/FTEmulator-api.git"
}

variable "api_auth_service_host" {
  description = "Auth service host"
  type        = string
  default     = "auth-service.auth.svc.cluster.local"
}

variable "api_auth_service_port" {
  description = "Auth service port"
  type        = string
  default     = "30002"
}

variable "api_localhost" {
  description = "API Localhost"
  type        = string
  default     = "localhost"
}

variable "api_localport" {
  description = "API Localport"
  type        = string
  default     = "8080"
}

variable "api_profile_service_host" {
  description = "Profile service host"
  type        = string
  default     = "profile-service.profile.svc.cluster.local"
}

variable "api_profile_service_port" {
  description = "Profile service port"
  type        = string
  default     = "30003"
}

# Job
variable "api_job_image" {
  description = "Gradle version"
  type        = string
  default     = "gradle:8.7.0-jdk21"
}

