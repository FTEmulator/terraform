# Proveedor
provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Variables
variable "nginx_version" {
  description = "Versión de nginx"
  default     = "latest"
}

variable "node_port" {
  description = "Puerto del nodo conectar con la salida al exterior"
  default     = "31234"
}