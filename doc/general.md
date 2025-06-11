# Main.tf
En main.tf se define el proveedor (kubernetes) y los modulos que tiene que ejecutar

# Estructura
├── kind-config.yaml
├── main.tf
└── website
    ├── deployment.tf
    ├── flux
    │   ├── gitRepository.yaml
    │   ├── job.yaml
    │   └── kustomization.yaml
    ├── job.tf
    ├── namespace.tf
    ├── service.tf
    ├── storage.tf
    ├── terraform.tfstate
    └── variables.tf

# ./website
Esta carpeta tiene todo lo necesario para desplegar la pagina web y al mismo tiempo actualizarla siempre a la ultima version del repositorio de la web.