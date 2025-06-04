# Variables
variable "nginx_version" {
  description = "Versión de Nginx a utilizar"
  type        = string
  default     = "latest"
}

variable "node_port" {
  description = "Puerto NodePort para exponer el servicio de Nginx"
  type        = number
  default     = 31234
}