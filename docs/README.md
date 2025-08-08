# 📚 Tempo - Documentación Completa

## 🎯 Descripción General

**Tempo** es una aplicación móvil de charadas desarrollada en Flutter que permite a los usuarios jugar un juego de adivinanzas por equipos. La aplicación incluye categorías predefinidas y personalizadas, historial de partidas, y una interfaz moderna con soporte para temas claro y oscuro.

## 📋 Índice de Documentación

### 🏗️ Arquitectura y Estructura

- [Arquitectura de la Aplicación](./architecture/README.md)
- [Estructura de Directorios](./architecture/directory-structure.md)
- [Patrones de Diseño](./architecture/design-patterns.md)

### 🎮 Funcionalidades

- [Guía de Usuario](./features/user-guide.md)
- [Sistema de Juego](./features/game-system.md)
- [Gestión de Categorías](./features/categories.md)
- [Historial de Partidas](./features/game-history.md)

### 💻 Desarrollo Técnico

- [Configuración del Proyecto](./development/setup.md)
- [Dependencias y Librerías](./development/dependencies.md)
- [Modelos de Datos](./development/data-models.md)
- [Servicios y Lógica de Negocio](./development/services.md)
- [Interfaz de Usuario](./development/ui-components.md)

### 🎨 Diseño y UX

- [Sistema de Colores](./design/color-system.md)
- [Tipografía](./design/typography.md)
- [Componentes UI](./design/ui-components.md)
- [Temas (Claro/Oscuro)](./design/themes.md)

### 📱 Plataformas

- [Configuración Android](./platforms/android.md)
- [Configuración iOS](./platforms/ios.md)

### 🚀 Despliegue

- [Build y Release](./deployment/build-release.md)
- [Configuración de Iconos](./deployment/app-icons.md)

## 🎯 Características Principales

- **Juego de Charadas**: Sistema completo de juego por turnos
- **Categorías Personalizables**: Crear y gestionar categorías propias
- **Historial de Partidas**: Seguimiento de resultados y estadísticas
- **Temas Adaptativos**: Soporte para modo claro y oscuro
- **Orientación Flexible**: Adaptación automática a orientación del dispositivo
- **Efectos de Sonido**: Feedback auditivo durante el juego
- **Almacenamiento Local**: Persistencia de datos con Hive

## 🛠️ Tecnologías Utilizadas

- **Framework**: Flutter 3.8.1+
- **Lenguaje**: Dart
- **Base de Datos**: Hive (NoSQL local)
- **Gestión de Estado**: Provider
- **Audio**: audioplayers
- **Sensores**: sensors_plus
- **UI**: Material Design 3

## 📱 Requisitos del Sistema

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Flutter**: 3.8.1 o superior
- **Dart**: 3.0.0 o superior

## 🚀 Inicio Rápido

1. **Clonar el repositorio**

   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd App
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📖 Cómo Usar Esta Documentación

Esta documentación está organizada de manera modular para facilitar la navegación:

- **Desarrolladores**: Comienza con [Configuración del Proyecto](./development/setup.md)
- **Diseñadores**: Revisa [Sistema de Colores](./design/color-system.md) y [Componentes UI](./design/ui-components.md)
- **Usuarios**: Consulta [Guía de Usuario](./features/user-guide.md)
- **Arquitectos**: Explora [Arquitectura de la Aplicación](./architecture/README.md)

## 🤝 Contribución

Para contribuir al proyecto:

1. Revisa la [Arquitectura de la Aplicación](./architecture/README.md)
2. Consulta las [Guías de Desarrollo](./development/setup.md)
3. Sigue los patrones establecidos en [Patrones de Diseño](./architecture/design-patterns.md)

## 📞 Soporte

Si encuentras problemas o tienes preguntas:

1. Revisa la [Guía de Usuario](./features/user-guide.md)
2. Consulta la [Documentación Técnica](./development/README.md)
3. Abre un issue en el repositorio

---

**Última actualización**: Diciembre 2024  
**Versión de la aplicación**: 0.1.0  
**Flutter**: 3.8.1+
