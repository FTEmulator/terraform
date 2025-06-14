# Main.tf
En main.tf se define el proveedor (Kubernetes) y los módulos que tiene que ejecutar

# kind-config.yaml
Aquí se definen los puertos con los que salen los servicios al exterior del cluster.

- ref: 

# Despliegue de pods con repositorios
## Módulos dependientes:
- /website
- /api

## Descripción
Desplegara un pod con el repositorio correspondiente, lo compilara y lo servirá. Ejemplo con el modulo /website: primeramente creara un pod de nginx, un volumen persistente y un job, el job descargara el repositorio, lo compilara y lo mandara al volumen persistente, una vez allí la pagina web pedirá acceso al almacenamiento y suplirá los archivos.

Una vez suplida la pagina se creara otro job el cual hará uso de flux para la actualización del repositorio. Resumidamente flux tendrá un gitRepository.yaml que descargara el repositorio continuamente y lo comparara, cuando detecte una diferencia hará que el kustomizarion.yaml lance un job que actualice la pagina.

# explicación de utilidad de archivos con /website

## Entorno (namespace.tf)
Todos los recursos se crean en un entorno, en terraform se llama namespace, en el cual con un nombre se agrupan los servicios, pods, jobs... En el caso de la pagina web y sus jobs se agruparan en el namespace website.

## Servicio (deployment.tf / service.tf)
Primeramente en deployment.tf se definen las características que debe tener el servidor de nginx, y el enrutamiento de puertos se define en service.tf.

-ref:   https://github.com/hashicorp-education/learn-terraform-deploy-nginx-kubernetes-provider

## PV / PVC (storage.tf)
PV significa Persistent volume, la pagina web requiere de uno para almacenar los archivos de la pagina, y el PVC que significa Persistent Volume Claim se usara para que los job puedan pedir ese almacenamiento.

-ref:   https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume

        https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim

## Jobs (job.tf)
A la hora de crear el servidor nginx se ejecuta un job el cual descarga el repositorio de github, lo compila y lo almacena en el PV usando el PVC

-ref:   https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job

## Flux
Flux lo que hace es visualizar las actualizaciones del repositorio de la web y en caso de actualizarse lanza un job que actualizara la misma.

Para ello en /flux podemos encontrar gitRepository.yaml que es el que mira los cambios del repositorio descargándolo y comparándolo continuamente. En cuanto ve un cambio kustomization.yaml se ejecuta y busca la carpeta flux en el repo, esa carpeta contendrá un job.yaml que utilizara para actualizar la pagina.

Ademas para que se puedan hacer múltiples jobs para las actualizaciones los job tenían que tener distinto nombre entonces con github workflow al hacer commit el nombre del job se cambia automáticamente.

-ref:   https://fluxcd.io/flux/components/source/gitrepositories/?utm_source=chatgpt.com
        https://fluxcd.io/flux/components/kustomize/kustomizations/?utm_source=chatgpt.com
        https://github.com/orgs/community/discussions/26842

