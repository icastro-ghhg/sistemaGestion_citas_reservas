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
- [Licencia](#-licencia)

---

## ✅ Requisitos

- **Flutter** 3.x (canal *stable*) y **Dart** 3.x  
- **Android SDK** configurado
- **Cuenta de Firebase** (proyecto Android) con **Google Sign-In** habilitado
- Acceso a la API `https://api.sebastian.cl/vote`

---

## 📦 Instalación

1. **Clona** el repositorio:
   ```bash
   git clone <tu-repo.git>
   cd <tu-repo>
