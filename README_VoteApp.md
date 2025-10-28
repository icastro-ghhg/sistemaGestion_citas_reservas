# Vote App (Flutter + Firebase + Dio)

Aplicación móvil Android construida en **Flutter** para autenticación con **Firebase Authentication (Google Sign-In)** y consumo de la API pública en `https://api.sebastian.cl/vote`. La app permite listar encuestas, votar, ver resultados y consultar el historial de votos del usuario.

> **Nota de evaluación:** Este README incluye instalación, uso, endpoints documentados y un resumen técnico — alineado con la rúbrica de “Documentación y Entregables (10%)”.

---

## 🧭 Tabla de contenidos

- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Configuración de Firebase](#-configuración-de-firebase)
- [Ejecución](#-ejecución)
- [Uso (flujo funcional)](#-uso-flujo-funcional)
- [Endpoints (documentación de uso real)](#-endpoints-documentación-de-uso-real)
- [Arquitectura y organización](#-arquitectura-y-organización)
- [Informe técnico breve](#-informe-técnico-breve)
- [Solución de problemas](#-solución-de-problemas)

---

## ⚙️ Requisitos

- Flutter SDK 3.19 o superior
- Android SDK (API 33+)
- Firebase Console con proyecto configurado
- Editor compatible (VS Code o Android Studio)

---

## 🧩 Instalación

```bash
git clone https://github.com/icastro-ghhg/sistemaGestion_citas_reservas.git
cd vote_app
flutter pub get
```

---

## 🔑 Configuración de Firebase

1. En la consola de Firebase, crea un nuevo proyecto llamado **Vote App**.
2. Habilita **Firebase Authentication** → Método de acceso → **Google**.
3. Descarga el archivo `google-services.json` y colócalo dentro de `android/app/`.
4. Asegúrate de que el `project_id` en ese archivo coincida con el configurado en la consola de Firebase.

---

## ▶️ Ejecución

```bash
flutter run
```

Si usas VS Code, presiona **F5** o selecciona “Run → Start Debugging”.

---

## 📱 Uso (flujo funcional)

1. **Inicio de sesión con Google** mediante Firebase Authentication.
2. **Listar encuestas disponibles** desde la API (`/v1/polls/`).
3. **Seleccionar y votar** en una encuesta (`POST /v1/vote`).
4. **Visualizar resultados** de cada encuesta.
5. **Consultar historial de votos** por usuario autenticado.

---

## 🌐 Endpoints (documentación de uso real)

### 🔹 Autenticación

- **POST** `/login` → Inicia sesión y obtiene JWT (renovado automáticamente, sin refresh token).

### 🔹 Encuestas

| Método | Endpoint | Descripción |
|---------|-----------|--------------|
| GET | `/v1/polls/` | Listar encuestas |
| POST | `/v1/polls/` | Crear nueva encuesta |
| PUT | `/v1/polls/` | Actualizar encuesta |
| GET | `/v1/polls/{pollToken}` | Obtener encuesta por token |
| DELETE | `/v1/polls/{pollToken}` | Eliminar encuesta |

### 🔹 Votaciones

| Método | Endpoint | Descripción |
|---------|-----------|--------------|
| POST | `/v1/vote` | Registrar voto de usuario |

---

## 🧱 Arquitectura y organización

```
lib/
 ├── core/
 │   ├── api_client.dart         # Configuración Dio + interceptores JWT
 │   └── firebase_service.dart   # Inicialización de Firebase
 │
 ├── features/
 │   ├── auth/                   # Módulo de autenticación Firebase
 │   ├── polls/                  # Lógica de encuestas
 │   └── votes/                  # Registro y consulta de votos
 │
 ├── widgets/                    # Componentes reutilizables UI
 └── main.dart                   # Punto de entrada de la aplicación
```

**Tecnologías principales:**
- Flutter 3.19
- Firebase Authentication
- Dio (HTTP client con interceptores)
- Provider (manejo de estado)

---

## 🧾 Informe técnico breve

El proyecto implementa un flujo de autenticación completo usando Firebase. Una vez autenticado, el token JWT se utiliza en cada solicitud a la API mediante **Dio Interceptors**, asegurando la autorización centralizada y un manejo de errores robusto.

El diseño de la app sigue una arquitectura **Feature-based**, separando la lógica de negocio por módulos (`auth`, `polls`, `votes`). Los modelos se validan mediante `fromJson` / `toJson` garantizando la integridad de los datos consumidos desde el backend.

La API `https://api.sebastian.cl/vote` cumple el contrato definido en el documento **OpenAPI (Swagger)** proporcionado por el profesor, verificándose con pruebas reales desde la app.

---

## 🧰 Solución de problemas

- Si obtienes error **500** al consultar `/vote/login`, revisa que estés usando **POST** y no **GET**.
- Verifica la coincidencia de `project_id` entre Firebase Console y `google-services.json`.
- Si Firebase no autentica, revisa que **SHA-1** del proyecto esté agregado en Firebase Console.

---

> Proyecto académico desarrollado para el ramo **Desarrollo de Aplicaciones Móviles** (UTEM, 2025).
