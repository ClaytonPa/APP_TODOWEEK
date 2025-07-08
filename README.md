# 📋 Flutter To-Do List App

Una aplicación de lista de tareas (To-Do List) desarrollada con **Flutter**, compatible con **dispositivos móviles (iOS/Android)** y **web** (limitado si SQLite no es soportado en navegador).  

Permite gestionar tareas de forma simple con almacenamiento local mediante **SQLite**.

---

## 🆕 Actualización reciente

Se ha integrado autenticación y sincronización en la nube con **Firebase**:

- 🔐 Inicio de sesión con **Google** y **correo/contraseña** usando Firebase Authentication.
- ☁️ Identificación de usuarios y manejo seguro de sesiones.
- ⚙️ Configuración incluida en `firebase_options.dart` y `google-services.json`.

> Estas mejoras permiten que cada usuario acceda de forma personalizada a su cuenta, preparando la app para una futura sincronización completa en la nube.

---

## ✨ Características

- ✅ Agregar nuevas tareas
- 📝 Editar y eliminar tareas existentes
- 📌 Marcar tareas como completadas
- 💾 Almacenamiento persistente usando SQLite
- 🔐 Autenticación con Google y correo/contraseña
- ☁️ Sincronización de usuario con Firebase Authentication
- 📱 Multiplataforma: soporta Android, iOS y Web

> Nota: Actualmente no se soporta ordenamiento por estado o fecha.

---

## 🚀 Instalación y ejecución

### Prerrequisitos

Asegúrate de tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Un editor como [Visual Studio Code](https://code.visualstudio.com/) o Android Studio
- Dispositivo físico o emulador/simulador


ℹ️ SQLite no es completamente soportado en la web, por lo que algunas funcionalidades pueden estar limitadas o no disponibles.

🛠️ Tecnologías utilizadas
Flutter

Dart

sqflite – Plugin SQLite para Flutter

Firebase Authentication

Google Sign-In

🧪 Futuras mejoras
🔔 Notificaciones locales

📅 Ordenamiento por fecha o estado

🌓 Modo oscuro

☁️ Sincronización completa de tareas en la nube

🛠️ Solución de Problemas
🔥 Error al compilar: firebase_options.dart no encontrado
Si al intentar compilar la app ves un error como:

bash
Copy
Edit
lib/main.dart:3:8: Error: Error when reading 'lib/firebase_options.dart': The system cannot find the file specified.
Este archivo (firebase_options.dart) no está incluido en el repositorio por razones de seguridad, ya que suele ser ignorado en .gitignore. Este archivo es generado automáticamente al conectar tu app con Firebase mediante FlutterFire.

✅ ¿Cómo solucionarlo?
Puedes resolverlo de una de las siguientes formas:

Generar el archivo nuevamente con FlutterFire CLI:

Asegúrate de tener instalado flutterfire:

bash
Copy
Edit
dart pub global activate flutterfire_cli
Luego ejecuta:

bash
Copy
Edit
flutterfire configure
Esto volverá a generar el archivo firebase_options.dart con la configuración correcta.

Copiar el archivo manualmente:

Si ya lo tienes en otra copia local del proyecto, simplemente colócalo en la carpeta:

bash
Copy
Edit
lib/firebase_options.dart

### Ejecutar en dispositivos móviles

```bash
flutter pub get
flutter run
