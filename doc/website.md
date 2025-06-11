# Entorno (namespace.tf)
Todos los recursos se crean en un entorno, en terraform se llama namespace, en el cual con un nombre se agrupan los servicios, pods, jobs... En el caso de la pagina web y sus jobs se agruparan en el namespace website.

# Servicio (deployment.tf / service.tf)
Primeramente en deployment.tf se definen las caracteristicas que deve tener el servidor de nginx, y la redireccion de puertos se define en service.tf.

-ref:   https://github.com/hashicorp-education/learn-terraform-deploy-nginx-kubernetes-provider

# PV / PVC (storage.tf)
PV significa Persistent volume, la pagina web requiere de uno para almacenar los archivos de la pagina, y el PVC que significa Persistent Volume Claim se usara para que los job puedan pedir ese almacenamiento.

-ref:   https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume

        https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim

# Jobs (job.tf)
A la hora de crear el servidor nginx se ejecuta un job el cual descarga el repositorio de github, lo compila y lo almacena en el PV usando el PVC

-ref:   https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job

# Flux
Flux lo que hace es visualizar las actualizaciones del repositorio de la web y en caso de actualizarse lanza un job que actualizara la misma.

Para ello en /flux podemos encontrar gitRepository.yaml que es el que mira los cambios del repositorio descargandolo y comparandolo continuamente. En cuanto ve un cambio kustomization.yaml se ejecuta y busca la carpeta flux en el repo, esa carpeta contendra un job.yaml que utilizara para actualizar la pagina.

Ademas para que se puedan hacer multiples jobs para las actualizaciones los job tenian que tener distinto nombre asique con github workflow al hacer commit el nombre del job se cambia atumaticamente.

-ref:   https://fluxcd.io/flux/components/source/gitrepositories/?utm_source=chatgpt.com
        https://fluxcd.io/flux/components/kustomize/kustomizations/?utm_source=chatgpt.com
        https://github.com/orgs/community/discussions/26842