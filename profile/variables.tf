variable "profile_version" {
    description = "Version de jdk a utilizar"
    type = string
    default = "latest"
}

variable "jdk_port" {
    description = "Puerto jdkPort para exponer el servicio de la api"
    type        = number
    default     = 30003
}

variable "postgres_port" {
    description = "Puerto de postgres"
    type        = number
    default     = 5432
}

variable "jdkVersion" {
  	description = "Version de gradle"
  	type        = string
  	default     = "8.7.0-jdk21"
}

variable "deployVersion" {
    description = "Version del deploy"
  	type        = string
  	default     = "eclipse-temurin:21-jdk"
}

variable "git_repo" {
  	description = "Repositorio de github"
  	type = string
  	default = "https://github.com/FTEmulator/profile.git"
}