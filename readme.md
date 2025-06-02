# Introducción
En este repositorio se encuentra el archivo de configuracion del cluster de kubernetes y los archivos de terraform para el despliege de la infraestructura.

# Configuración del cluster
Con kinf-config.yaml crearemos el cluster:
```bash
sudo kind create cluster --config kind-config.yaml
```

# Despliege de terraform
A continuacion desplegaremos toda la infraestructura:

Comprobamos que esta todo bien
```bash
sudo kubernetes init
```

Desplegamos (hay que poner "yes")
```bash
sudo kubernetes init
```