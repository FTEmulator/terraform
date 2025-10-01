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

# Job
variable "api_job_image" {
  description = "Version de gradle"
  type        = string
  default     = "gradle:8.7.0-jdk21"
}






variable "git_repo" {
  description = "Repositorio de github"
  type = string
  default = "https://github.com/FTEmulator/FTEmulator-api.git"
}