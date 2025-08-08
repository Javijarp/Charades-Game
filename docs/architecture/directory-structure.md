# 📁 Estructura de Directorios

## 🎯 Visión General

La estructura de directorios de Tempo está organizada siguiendo principios de **Clean Architecture** y **Feature-First Organization**. Cada directorio tiene una responsabilidad específica y está diseñado para facilitar la navegación y mantenimiento del código.

## 🏗️ Estructura Completa

```
App/
├── 📱 android/                    # Configuración específica de Android
│   ├── app/
│   │   ├── build.gradle.kts      # Configuración de build
│   │   └── src/
│   │       ├── main/
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── kotlin/       # Código nativo de Android
│   │       │   └── res/          # Recursos de Android
│   │       └── debug/            # Configuración de debug
│   ├── build.gradle.kts
│   └── gradle/
├── 🍎 ios/                       # Configuración específica de iOS
│   ├── Runner/
│   │   ├── AppDelegate.swift     # Delegado de la aplicación
│   │   ├── Assets.xcassets/      # Recursos de iOS
│   │   └── Info.plist           # Configuración de iOS
│   ├── Podfile                  # Dependencias de CocoaPods
│   └── Runner.xcodeproj/        # Proyecto de Xcode
├── 🎨 assets/                    # Recursos estáticos
│   ├── icon/
│   │   └── app_icon.png         # Icono de la aplicación
│   └── sounds/                  # Archivos de audio
│       ├── correct.mp3
│       ├── pass.mp3
│       └── ...
├── 📚 docs/                      # Documentación (NUEVO)
│   ├── README.md                # Documentación principal
│   ├── architecture/            # Documentación de arquitectura
│   ├── development/             # Guías de desarrollo
│   ├── features/                # Documentación de funcionalidades
│   ├── design/                  # Documentación de diseño
│   ├── platforms/               # Configuración de plataformas
│   └── deployment/              # Guías de despliegue
├── 💻 lib/                      # Código fuente principal
│   ├── core/                    # Configuraciones globales
│   │   └── color.dart           # Sistema de colores
│   ├── main.dart                # Punto de entrada de la aplicación
│   └── src/                     # Código fuente organizado
│       ├── models/              # Modelos de datos
│       ├── screens/             # Pantallas de la aplicación
│       ├── services/            # Lógica de negocio
│       └── widgets/             # Componentes reutilizables
├── 📋 pubspec.yaml              # Configuración del proyecto
├── 📋 pubspec.lock              # Versiones bloqueadas de dependencias
└── 📖 README.md                 # README del proyecto
```

## 📂 Detalle de Directorios Principales

### 🎯 `lib/` - Código Fuente Principal

#### `lib/core/`

**Propósito**: Configuraciones y utilidades globales de la aplicación.

```
lib/core/
└── color.dart                   # Sistema de colores y temas
```

**Contenido**:

- Definición de colores para modo claro y oscuro
- Constantes de diseño globales
- Configuración de temas

#### `lib/src/` - Código Organizado por Funcionalidad

##### `lib/src/models/`

**Propósito**: Modelos de datos y entidades de la aplicación.

```
lib/src/models/
├── category.dart                # Modelo de categoría
├── category.g.dart             # Código generado por Hive
├── game_history.dart           # Modelo de historial de juego
├── game_history.g.dart         # Código generado por Hive
└── duration_adapter.dart       # Adaptador para Duration
```

**Responsabilidades**:

- Definición de estructuras de datos
- Anotaciones de Hive para persistencia
- Lógica de serialización/deserialización

##### `lib/src/screens/`

**Propósito**: Pantallas y vistas de la aplicación organizadas por funcionalidad.

```
lib/src/screens/
├── home/                       # Pantalla principal
│   └── home_screen.dart
├── categories/                 # Gestión de categorías
│   ├── category_selection_screen.dart
│   ├── create_custom_category_screen.dart
│   └── more_categories_screen.dart
└── game/                      # Pantallas del juego
    ├── countdown_screen.dart
    ├── game_over_screen.dart
    ├── game_setup_screen.dart
    ├── gameplay_screen.dart
    ├── history_screen.dart
    └── how_to_play_screen.dart
```

**Organización**:

- **home/**: Pantalla principal y navegación
- **categories/**: Gestión y selección de categorías
- **game/**: Flujo completo del juego

##### `lib/src/services/`

**Propósito**: Lógica de negocio y servicios de la aplicación.

```
lib/src/services/
├── category_service.dart       # Gestión de categorías
├── game_history_service.dart   # Gestión de historial
├── game_settings.dart          # Configuración del juego
├── orientation_manager.dart    # Gestión de orientación
└── unlocked_orientation_mixin.dart
```

**Responsabilidades**:

- Lógica de negocio
- Comunicación con base de datos
- Gestión de estado de la aplicación

##### `lib/src/widgets/`

**Propósito**: Componentes reutilizables de la interfaz de usuario.

```
lib/src/widgets/
├── score_display.dart          # Widget de puntuación
└── tempo_button.dart           # Botón personalizado
```

**Características**:

- Componentes modulares
- Reutilizables en múltiples pantallas
- Configurables y flexibles

### 🎨 `assets/` - Recursos Estáticos

#### `assets/icon/`

**Propósito**: Iconos y recursos gráficos de la aplicación.

```
assets/icon/
└── app_icon.png               # Icono principal de la aplicación
```

#### `assets/sounds/`

**Propósito**: Archivos de audio para efectos de sonido.

```
assets/sounds/
├── copper-bell-ding-23-215438.mp3
├── correct.mp3                # Sonido de respuesta correcta
├── pass.mp3                   # Sonido de pasar palabra
├── rightanswer-95219.mp3
└── successed-295058.mp3
```

### 📱 `android/` - Configuración de Android

```
android/
├── app/
│   ├── build.gradle.kts       # Configuración de build de la app
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml  # Permisos y configuración
│       │   ├── kotlin/              # Código nativo de Android
│       │   └── res/                 # Recursos de Android
│       └── debug/                   # Configuración de debug
├── build.gradle.kts           # Configuración de build del proyecto
└── gradle/                    # Configuración de Gradle
```

### 🍎 `ios/` - Configuración de iOS

```
ios/
├── Runner/
│   ├── AppDelegate.swift      # Delegado de la aplicación
│   ├── Assets.xcassets/       # Recursos gráficos
│   ├── Info.plist            # Configuración de la app
│   └── Base.lproj/           # Archivos de localización
├── Podfile                   # Dependencias de CocoaPods
└── Runner.xcodeproj/         # Proyecto de Xcode
```

## 📋 Archivos de Configuración

### `pubspec.yaml`

**Propósito**: Configuración principal del proyecto Flutter.

**Contenido principal**:

- Nombre y descripción del proyecto
- Dependencias de desarrollo y producción
- Configuración de assets
- Configuración de iconos de la aplicación

### `analysis_options.yaml`

**Propósito**: Configuración de análisis estático de código.

**Incluye**:

- Reglas de linting
- Configuración de análisis de código
- Excepciones y configuraciones específicas

## 🔄 Flujo de Organización

### 1. Separación por Capas

```
Presentation Layer → Business Layer → Data Layer
     (screens)           (services)      (models)
```

### 2. Organización por Funcionalidad

```
Feature-based Organization:
├── categories/          # Todo lo relacionado con categorías
├── game/               # Todo lo relacionado con el juego
└── home/               # Pantalla principal
```

### 3. Separación de Responsabilidades

```
Models:     Estructuras de datos
Services:   Lógica de negocio
Screens:    Interfaz de usuario
Widgets:    Componentes reutilizables
```

## 🎯 Beneficios de esta Estructura

### 1. **Escalabilidad**

- Fácil adición de nuevas funcionalidades
- Organización clara para equipos grandes

### 2. **Mantenibilidad**

- Código organizado y fácil de encontrar
- Separación clara de responsabilidades

### 3. **Testabilidad**

- Servicios aislados para testing
- Componentes modulares

### 4. **Navegación**

- Estructura intuitiva
- Fácil localización de archivos

## 📝 Convenciones de Nomenclatura

### Archivos

- **snake_case**: `game_setup_screen.dart`
- **Descriptivo**: Nombres que describan la funcionalidad

### Directorios

- **snake_case**: `category_selection_screen.dart`
- **Funcionalidad**: Agrupados por características

### Clases

- **PascalCase**: `GameSetupScreen`
- **Sufijos descriptivos**: `Screen`, `Service`, `Widget`

---

**Anterior**: [Arquitectura de la Aplicación](./README.md) | **Siguiente**: [Patrones de Diseño](./design-patterns.md)
