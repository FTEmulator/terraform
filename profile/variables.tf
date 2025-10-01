# Namespace
variable "profile_namespace" {
    description = "Namespace name"
    type        = string
    default     = "profile"
  
}

# Ports
variable "profile_api_port" {
    description = "JDK port"
    type        = number
    default     = 30003
}

variable "profile_postgres_port" {
    description = "Postgres port"
    type        = number
    default     = 5432
}

# Api
variable "profile_api_image" {
    description = "API image"
  	type        = string
  	default     = "eclipse-temurin:21-jdk"
}

variable "profile_api_cpu" {
    description = "API CPU"
    type        = string
    default     = "500m"
}

variable "profile_api_memory" {
    description = "API Memory"
    type        = string
    default     = "512Mi"
  
}

variable "profile_db_url" {
    description = "Database URL"
    type        = string
    default     = "jdbc:postgresql://postgres-service.profile.svc.cluster.local:5432/profile"
  
}

variable "profile_api_pv_storage" {
    description = "Persistent Volume Storage"
    type        = string
    default     = "1Gi"
}

variable "profile_git_repo" {
  	description = "API repo"
  	type = string
  	default = "https://github.com/FTEmulator/profile.git"
}

# Postgres
variable "profile_postgres_image" {
    description = "Postgres image"
    type        = string
    default     = "postgres:17"
  
}

variable "profile_postgres_user" {
    description = "Postgres user"
    type        = string
    default     = "profile_user"
}

variable "profile_postgres_password" {
    description = "Postgres password"
    type        = string
    default     = "Almi123"
}

variable "profile_postgres_cpu" {
    description = "Postgres CPU"
    type        = string
    default     = "500m"
  
}

variable "profile_postgres_memory" {
    description = "Postgres Memory"
    type        = string
    default     = "512Mi"
  
}

variable "profile_postgres_pv_storage" {
    description = "Persistent Volume Storage"
    type        = string
    default     = "1Gi"
}

# Job
variable "profile_job_image" {
  	description = "Gradle version"
  	type        = string
  	default     = "gradle:8.7.0-jdk21"
}