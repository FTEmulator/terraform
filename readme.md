# Introducción
En este repositorio se encuentra el archivo de configuración del cluster de kubernetes y los archivos de terraform para el despliege de la infraestructura.

# Configuración del cluster
Con kinf-config.yaml crearemos el cluster:
```bash
sudo kind create cluster --config kind-config.yaml
```

# Despliege de terraform
A continuación desplegaremos toda la infraestructura:

Comprobamos que esta todo bien
```bash
sudo kubernetes init
```

Desplegamos (hay que poner "yes")
```bash
sudo kubernetes init
```

# Links de referencia
Cluster: https://kind.sigs.k8s.io/docs/user/quick-start/

## website
Persistent volume: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume
Job: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job
PV: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume
PVC: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim
Nginx deploy: https://github.com/hashicorp-education/learn-terraform-deploy-nginx-kubernetes-provider
Terraform repository deploy: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
Git event runner: https://alex-karpenko.github.io/git-events-runner/v0.4/intro/quick-start/