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
sudo kubernetes apply
```

# Documentacion
Si deseas saber que se crea y como se crea te recomiendo consultar la carpeta /doc, ahi encontraras todo lo necesario.

# Links de referencia
Cluster: https://kind.sigs.k8s.io/docs/user/quick-start/