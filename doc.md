# Main.tf
En main.tf se define el proveedor (kubernetes) y los modulos que tiene que ejecutar

# Estructura
main.tf
|--website
|  |--variables.tf
|  |--namespace.tf
|  |--storage.tf
|  |--job.tf
|  |--deployment.tf
|  |--service.tf
|  |--gitEventRunner
|     |--

# ./website
Esta carpeta tiene todo lo necesario para desplegar la pagina web.

Primero crea un volumen persistente y un pvc. Posteriormente crea un job el cual clona el repositorio, lo compila y lo introduce en el volumen persistente, asi al crear el pod de nginx podra acceder a los archivos estaticos. Y finalmente se crea un git event runner para que cada vez que se actualize el repositorio se actualice.