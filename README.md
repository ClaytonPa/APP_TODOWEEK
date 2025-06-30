# 📋 Flutter To-Do List App

Una aplicación de lista de tareas (To-Do List) desarrollada con **Flutter**, compatible con **dispositivos móviles (iOS/Android)** y **web** (limitado si SQLite no es soportado en navegador).  

Permite gestionar tareas de forma simple con almacenamiento local mediante **SQLite**.

## ✨ Características

- ✅ Agregar nuevas tareas
- 📝 Editar y eliminar tareas existentes
- 📌 Marcar tareas como completadas
- 💾 Almacenamiento persistente usando SQLite
- 📱 Multiplataforma: soporta Android, iOS y Web

> Nota: Actualmente no se soporta ordenamiento por estado o fecha.

## 🚀 Instalación y ejecución

### Prerrequisitos

Asegúrate de tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Un editor como [Visual Studio Code](https://code.visualstudio.com/) o Android Studio
- Dispositivo físico o emulador/simulador

### Ejecutar en dispositivos móviles

```bash
flutter pub get
flutter run

## Ejecutar en dispositivos móviles

flutter config --enable-web
flutter run -d chrome

ℹ️ SQLite no es completamente soportado en la web, por lo que algunas funcionalidades pueden estar limitadas o no disponibles.

📁 Estructura del proyecto

### 🛠️ Tecnologías utilizadas
-Flutter
-Dart
-sqflite – plugin SQLite para Flutter


### 🧪 Futuras mejoras

🔔 Notificaciones locales
📅 Ordenamiento por fecha o estado
🌓 Modo oscuro
☁️ Sincronización en la nube