Aplicación móvil Android construida en Flutter para autenticación con
Firebase Authentication (Google Sign-In) y consumo de la API pública en
https://api.sebastian.cl/vote. La app permite listar encuestas, votar,
ver resultados y consultar el historial de votos del usuario.

  Nota de evaluación: Este README incluye instalación, uso, endpoints
  documentados y un resumen técnico — alineado con la rúbrica de
  “Documentación y Entregables (10%)”.

------------------------------------------------------------------------

🧭 Tabla de contenidos

-   Requisitos
-   Instalación
-   Configuración de Firebase
-   Ejecución
-   Uso (flujo funcional)
-   Endpoints (documentación de uso real)
-   Arquitectura y organización
-   Informe técnico breve
-   Solución de errores comunes
-   Créditos

------------------------------------------------------------------------

🧩 Requisitos

-   Flutter SDK 3.22 o superior
-   Android Studio / VSCode con Dart plugin
-   Firebase project configurado
-   API pública disponible en https://api.sebastian.cl/vote
-   Dispositivo físico o emulador con Android 10+

------------------------------------------------------------------------

⚙️ Instalación

    # Clonar repositorio
    git clone https://github.com/usuario/vote_app.git

    # Entrar al proyecto
    cd vote_app

    # Instalar dependencias
    flutter pub get

------------------------------------------------------------------------

🔑 Configuración de Firebase

1.  Crear un proyecto en Firebase Console.

2.  Descargar el archivo google-services.json y colocarlo en:

        android/app/google-services.json

3.  Verificar que project_id coincida con el del archivo local.

4.  Habilitar Firebase Authentication con método Google Sign-In.

------------------------------------------------------------------------

▶️ Ejecución

    flutter run

  Si usas VSCode: presiona F5 o selecciona Run > Start Debugging.

------------------------------------------------------------------------

📱 Uso (flujo funcional)

1.  Inicio de sesión con Google → el usuario se autentica mediante
    Firebase.
2.  Listado de encuestas (GET /v1/polls/) → se muestran las encuestas
    disponibles.
3.  Votación (POST /v1/vote) → el usuario selecciona una opción y envía
    su voto.
4.  Resultados (GET /v1/polls/{pollToken}) → se muestran resultados en
    tiempo real.
5.  Historial de votos → se consultan los votos previos del usuario
    autenticado.

------------------------------------------------------------------------

🌐 Endpoints (documentación de uso real)

🔹 Autenticación

  Método   Endpoint   Descripción
  -------- ---------- --------------------------------------------------
  POST     /login     Inicia sesión (autenticación mediante token JWT)

🔹 Encuestas

  Método   Endpoint                Descripción
  -------- ----------------------- -------------------------------
  GET      /v1/polls/              Listar encuestas
  POST     /v1/polls/              Crear una nueva encuesta
  PUT      /v1/polls/              Actualizar encuesta existente
  GET      /v1/polls/{pollToken}   Obtener encuesta específica
  DELETE   /v1/polls/{pollToken}   Eliminar encuesta

🔹 Votaciones

  Método   Endpoint   Descripción
  -------- ---------- ----------------------------
  POST     /v1/vote   Registrar voto del usuario

  Nota: No se utiliza refresh token, el JWT se actualiza manualmente
  tras cada autenticación exitosa.

------------------------------------------------------------------------

🧱 Arquitectura y organización

    lib/
     ┣ core/
     ┃ ┣ api_client.dart         # Cliente HTTP con Dio e interceptores
     ┃ ┗ models/                 # Modelos de datos
     ┣ features/
     ┃ ┣ auth/                   # Lógica y UI de autenticación Firebase
     ┃ ┣ polls/                  # Listado y detalle de encuestas
     ┃ ┣ votes/                  # Registro de votos y resultados
     ┗ main.dart                 # Punto de entrada

------------------------------------------------------------------------

🧮 Informe técnico breve

Framework: Flutter
Backend: Firebase Authentication + API REST pública
Manejo de datos: Dio (HTTP), interceptores y validación de modelos
Serialización: JSON a clases Dart (manual y automática)
Autenticación: Google Sign-In (Firebase)
Gestión de estado: Provider
Control de errores: manejo centralizado de respuestas HTTP con mensajes
personalizados.

El diseño sigue una arquitectura modular por características
(feature-based) que facilita la escalabilidad. Cada módulo encapsula su
lógica, vistas y controladores, reduciendo dependencias cruzadas.

------------------------------------------------------------------------

🧩 Solución de errores comunes

  -----------------------------------------------------------------------------------
  Problema                       Posible causa                 Solución
  ------------------------------ ----------------------------- ----------------------
  Firebase project_id mismatch   El ID de Firebase no coincide Revisar
                                                               google-services.json

  Error 500 en /vote/login       Endpoint incorrecto (usa      Cambiar método HTTP
                                 POST, no GET)                 

  DioError: Timeout              API sin conexión o token      Verificar conexión y
                                 inválido                      token JWT
  -----------------------------------------------------------------------------------

------------------------------------------------------------------------

👥 Créditos

Desarrollado por Equipo Vote App
UTEM — 2025

------------------------------------------------------------------------
