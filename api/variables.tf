variable "api_version" {
  description = "Versión de jdk a utilizar"
  type        = string
  default     = "latest"
}

variable "node_port" {
  description = "Puerto NodePort para exponer el servicio de la api"
  type        = number
  default     = 30000
}

variable "nodeVersion" {
  description = "Version de gradle"
  type        = string
  default     = "8.7.0-jdk21"
}

variable "git_repo" {
  description = "Repositorio de github"
  type = string
  default = "https://github.com/FTEmulator/FTEmulator-api.git"
}