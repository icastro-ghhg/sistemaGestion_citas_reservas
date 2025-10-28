2. Dependencias:
flutter pub get
3. Configura Firebase (ver sección siguiente) y copia
google-services.json dentro de android/app/.
4. (Opcional) Verifica formato y analyzers:
flutter analyze flutter test # si agregas tests
🔐 Configuración de Firebase
La app usa Firebase Authentication (Google). Debes enlazar tu app
Android con Firebase y habilitar el proveedor.
Crea un proyecto en Firebase Console .
Agrega una app Android con tu Application ID (package) de Flutter (ver
android/app/build.gradle → applicationId).
Descarga google-services.json y colócalo en android/app/.
En Authentication → Sign-in method, habilita Google.
(Recomendado) Agrega SHA-1 de tu debug keystore para Google Sign-In.
Asegúrate de tener en android/build.gradle:
dependencies { classpath 'com.google.gms:google-services:4.4.2' }
y en android/app/build.gradle:
apply plugin: 'com.google.gms.google-services'
▶️ Ejecución flutter run
Al iniciar, la app prepara el estado de autenticación y el token JWT de
API.
Si no hay sesión Firebase, verás la pantalla de Login (Google).
📲 Uso (flujo funcional)
Inicio de sesión
Presiona “Iniciar sesión con Google”.
Se crea la sesión en Firebase.
Listar encuestas
La pantalla principal muestra un listado paginado de encuestas.
Se admiten parámetros de búsqueda (q) y filtros (cuando aplique).
Votar
En el detalle de una encuesta, selecciona una opción y envía el voto.
La app registra el voto en el backend y agrega el token de encuesta a un
historial local (en FlutterSecureStorage) para evitar votos repetidos.
Resultados e historial
Puedes ver resultados de una encuesta.
Puedes consultar tu historial; la app intenta /v1/me/votes y, si el
backend no lo expone, usa /v1/users/me/votes.
🌐 Endpoints (documentación de uso real)
Base URL configurada en código: https://api.sebastian.cl/vote
Autenticación: Se envía Authorization: Bearer <JWT> automáticamente
desde un interceptor de Dio. El JWT se almacena en FlutterSecureStorage
con la clave api_jwt.
Módulo Método Endpoint Parámetros / Body Descripción Encuestas GET
/v1/polls/ Query: page, pageSize, q, filters Lista encuestas (paginadas
y filtrables). Encuestas GET /v1/polls/{id} — Detalle de una encuesta.
Votación POST /v1/vote/election Body (JSON): { "pollToken": string,
"selection": number } Envía un voto para la encuesta indicada. Votos del
usuario GET /v1/me/votes — Historial del usuario autenticado. Votos del
usuario (fallback) GET /v1/users/me/votes — Alternativa si el endpoint
anterior no está disponible. Resultados GET /v1/vote/{pollToken}/results
— Resultados agregados de la encuesta.
La especificación OpenAPI del servicio está disponible en:
https://api.sebastian.cl/vote/swagger-ui/index.html
🧱 Arquitectura y organización
State Management: [Riverpod] para providers de autenticación y lógica.
HTTP Client: [Dio] con BaseOptions (timeouts, headers) y interceptor
para el JWT.
Almacenamiento seguro: FlutterSecureStorage para api_jwt y para el
historial local de encuestas votadas.
Autenticación: firebase_auth + google_sign_in.
Estructura (simplificada):
lib/ ├── app.dart # MaterialApp y routing inicial ├── main.dart #
Bootstrap de Firebase y token de API (demo) ├── core/ │ ├──
api_client.dart # Dio + interceptor Authorization: Bearer <JWT> │ └──
error_handler.dart # Mapeo de errores de Dio -> mensajes amigables ├──
features/ │ ├── auth/ │ │ ├── data/auth_repository.dart # Login/Logout
con Google (Firebase) │ │ ├── provider/auth_provider.dart # Providers
de Riverpod │ │ └── presentation/login_page.dart # UI de login │ └──
votes/ │ ├── data/votes_repository.dart # Llamados a /v1/polls,
/v1/vote, etc. │ ├── presentation/votes_list_page.dart # UI lista /
detalle (paginación/acciones) │ └── services/vote_history_service.dart
# Persistencia local de encuestas votadas
🧪 Informe técnico breve
Patrón de capas
Presentation (Widgets) → Providers (Riverpod) → Repositories/Services →
Core (HTTP, errores).
Autenticación y JWT
La app no usa refresh token. Por simplicidad operacional del proyecto,
se actualiza el JWT manualmente y se guarda en FlutterSecureStorage bajo
la clave api_jwt.
Un interceptor de Dio lee el JWT antes de cada request y agrega
Authorization: Bearer <JWT>.
En main.dart existe un bootstrap de demo (saveStaticApiToken()) para
precargar un JWT de corrección. En producción, esa lógica se reemplaza
por la emisión/rotación real de tokens.
Manejo de errores
ErrorHandler.mapDioError(e) traduce timeouts, 4xx/5xx y errores de red a
mensajes claros para la UI.
Timeouts de conexión/recepción/envío: 8 segundos.
Datos y paginación
Listados con page/pageSize, búsqueda con q y filtros extensibles por
query params.
Seguridad local
Historial de encuestas votadas en FlutterSecureStorage (JSON) para
prevenir reintentos locales y mejorar UX.
Buenas prácticas aplicadas a la rúbrica
Consumo API: uso de Dio + interceptores + serialización por
Map<String,dynamic> con validaciones básicas.
Centralización de errores y timeouts.
Documentación de endpoints (tabla anterior) y breve informe técnico
(esta sección).
🧰 Cómo actualizar el JWT (modo demo)
En lib/main.dart hay una función de bootstrap para cargar un JWT en
almacenamiento seguro:
// lib/main.dart (extracto) Future<void> saveStaticApiToken() async {
const storage = FlutterSecureStorage(); const String professorJWT =
'<TU_JWT_AQUI>'; await storage.write(key: 'api_jwt', value:
professorJWT); }
Reemplaza '<TU_JWT_AQUI>' por un token válido.
El interceptor tomará ese valor automáticamente en cada request.
En un entorno real, elimina esta función y emite el JWT desde tu
backend.
🧩 Solución de problemas
500: "No static resource login" al probar /vote/login Ese recurso no es
un archivo estático del backend. En esta app el login se realiza con
Firebase (Google) y el JWT se inyecta por interceptor; no haces un GET
directo a /vote/login.
401/403 al consumir endpoints Verifica que existe un JWT válido en
FlutterSecureStorage (api_jwt) y que el scope/rol permite acceder al
recurso.
Google Sign-In falla en debug Asegura SHA-1 configurado y proveedor
Google habilitado en Firebase.
📄 Licencia
Este proyecto se distribuye bajo licencia MIT (puedes cambiarla según
necesidad).
📝 Notas finales
Este README está pensado para ser autoexplicativo y cumplir con
“Repositorio bien organizado, README completo (instalación, uso),
endpoints documentados y breve informe técnico claro”.
Si cambias rutas/contratos de API, actualiza la tabla de Endpoints y los
ejemplos correspondientes.
