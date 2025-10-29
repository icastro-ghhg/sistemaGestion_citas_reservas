Vote App - Proyecto de Computación Móvil



Estudiantes: Iván Castro, Cosntanza Garrido y Cristian Chala


Características Implementadas

Autenticación Segura: Inicio de sesión con Google a través de Firebase Authentication. La sesión de Firebase del usuario se gestiona de forma persistente.

Gestión de Sesión con JWT Estático: Para consumir la API del profesor, la aplicación utiliza un JWT estático que se carga al inicio y se almacena de forma segura. Esta solución se implementó como alternativa a la generación dinámica debido a restricciones de configuración entre proyectos de Firebase.

Listado de Encuestas: Muestra una lista de todas las encuestas disponibles obtenidas desde la API.

Detalle y Votación: Permite ver el detalle de una encuesta (descripción, opciones) y emitir un voto. El sistema previene el voto duplicado mostrando un mensaje claro al usuario.

Exploración de Resultados: Una sección dedicada a explorar los resultados de todas las encuestas, con funcionalidades de búsqueda y paginación.

Historial de Votaciones: El perfil del usuario consume un endpoint de la API para mostrar un historial de las encuestas en las que ha participado.

Manejo Completo de Estados: La interfaz de usuario representa claramente los estados de carga, éxito, lista vacía y error (con opción de reintento).

Calidad de Software: Incluye pruebas de widgets para las pantallas principales y está configurado con un flujo de Integración Continua (CI) en GitHub Actions.

Prerrequisitos

Para poder ejecutar este proyecto, necesitarás tener instalado:

Flutter SDK: Versión 3.22.0 o superior.

Un editor de código: Como Visual Studio Code o Android Studio.

Un emulador de Android o un dispositivo físico.


Instalación y Configuración

Sigue estos pasos para poner en marcha el proyecto:

Clonar el Repositorio:

git clone <URL_DEL_REPOSITORIO>
cd <NOMBRE_DEL_PROYECTO>

Detecta las huellas digitales SHA-1 y pasarselas a los administradores del grupo para que usted pueda compilar correctamente la app.


Instalar Dependencias:

flutter pub get

Paso previo a iniciar la app:
Ir a la api api.sebastian.cl, ingresar con cuenta de universidad para obtener el jwt.
Una vez obtenido, copiarlo.
Finalemente ir al maint.dart del proyecto y en la variable professorJWT reemplazar por la nueva clave obtenida.


Cómo Usar la Aplicación

Ejecutar la App:
Con un emulador en ejecución o un dispositivo conectado, corre:

flutter run


Iniciar Sesión:

La aplicación te pedirá iniciar sesión.

Usa el botón "Iniciar sesión con Google" y selecciona tu cuenta.

Navegación:

Pantalla Principal: Verás la lista de encuestas disponibles para votar.

Resultados: Usa el ícono de gráfico de barras

en la esquina superior derecha para explorar los resultados de las encuestas, con búsqueda y scroll infinito.

Perfil: Usa el ícono de persona para ver tu perfil y tu historial de votaciones.

Cómo Ejecutar las Pruebas

El proyecto incluye pruebas de widgets para validar la UI. Para ejecutarlas, corre:

flutter test
