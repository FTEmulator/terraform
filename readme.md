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
Kubernetes job with terraform: https://registry.terraform.io/providers/hashicorp/kubernetes/2.29.0/docs/resources/cron_job_v1
Nginx deploy: https://github.com/hashicorp-education/learn-terraform-deploy-nginx-kubernetes-provider
Terraform repository deploy: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository

# References
# PV: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume
# PVC: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim
# Job: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job