# 🏗️ Arquitectura de la Aplicación Tempo

## 📋 Visión General

Tempo sigue una arquitectura modular basada en **Clean Architecture** y **MVVM (Model-View-ViewModel)** con Provider para la gestión de estado. La aplicación está diseñada para ser escalable, mantenible y fácil de testear.

## 🎯 Principios Arquitectónicos

### 1. Separación de Responsabilidades

- **Models**: Entidades de datos y lógica de negocio
- **Views**: Interfaz de usuario y presentación
- **Services**: Lógica de aplicación y comunicación con datos
- **Widgets**: Componentes reutilizables de UI

### 2. Inversión de Dependencias

- Las capas superiores no dependen de las inferiores
- Uso de interfaces para desacoplar implementaciones
- Inyección de dependencias a través de Provider

### 3. Single Responsibility Principle

- Cada clase tiene una única responsabilidad
- Servicios especializados para diferentes funcionalidades
- Widgets modulares y reutilizables

## 🏛️ Estructura de Capas

```
┌─────────────────────────────────────┐
│           PRESENTATION LAYER        │
│  ┌─────────────────────────────────┐ │
│  │         Screens/Views           │ │
│  │  - HomeScreen                   │ │
│  │  - GameplayScreen               │ │
│  │  - CategorySelectionScreen      │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│           BUSINESS LAYER            │
│  ┌─────────────────────────────────┐ │
│  │         Services                │ │
│  │  - GameSettings                 │ │
│  │  - CategoryService              │ │
│  │  - GameHistoryService           │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│           DATA LAYER                │
│  ┌─────────────────────────────────┐ │
│  │         Models                  │ │
│  │  - Category                     │ │
│  │  - GameHistory                  │ │
│  │  - DurationAdapter              │ │
│  └─────────────────────────────────┘ │
│  ┌─────────────────────────────────┐ │
│  │         Storage                 │ │
│  │  - Hive Database                │ │
│  │  - Local File Storage           │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## 📁 Organización de Directorios

```
lib/
├── core/                    # Configuraciones globales
│   └── color.dart          # Sistema de colores
├── main.dart               # Punto de entrada
└── src/
    ├── models/             # Modelos de datos
    │   ├── category.dart
    │   ├── game_history.dart
    │   └── duration_adapter.dart
    ├── screens/            # Pantallas de la aplicación
    │   ├── home/           # Pantalla principal
    │   ├── categories/     # Gestión de categorías
    │   └── game/           # Pantallas del juego
    ├── services/           # Lógica de negocio
    │   ├── game_settings.dart
    │   ├── category_service.dart
    │   └── game_history_service.dart
    └── widgets/            # Componentes reutilizables
        ├── tempo_button.dart
        └── score_display.dart
```

## 🔄 Flujo de Datos

### 1. Inicialización de la Aplicación

```dart
main() → Hive.initFlutter() → Provider.setup() → TempoApp()
```

### 2. Gestión de Estado

```dart
User Action → Provider.notifyListeners() → UI Update
```

### 3. Persistencia de Datos

```dart
Service → Hive.box() → Local Storage
```

## 🎨 Patrones de Diseño Implementados

### 1. Provider Pattern

- **Propósito**: Gestión de estado global
- **Implementación**: `ChangeNotifierProvider` en `main.dart`
- **Uso**: `GameSettings`, `CategoryService`

### 2. Repository Pattern

- **Propósito**: Abstracción de acceso a datos
- **Implementación**: Servicios que encapsulan Hive
- **Uso**: `CategoryService`, `GameHistoryService`

### 3. Factory Pattern

- **Propósito**: Creación de objetos complejos
- **Implementación**: Constructores de modelos
- **Uso**: `Category`, `GameHistory`

### 4. Adapter Pattern

- **Propósito**: Adaptación de tipos de datos
- **Implementación**: `DurationAdapter` para Hive
- **Uso**: Serialización de `Duration` en Hive

## 🔧 Configuración de Dependencias

### Dependencias Principales

- **Hive**: Base de datos NoSQL local
- **Provider**: Gestión de estado
- **audioplayers**: Reproducción de audio
- **sensors_plus**: Acceso a sensores del dispositivo

### Configuración de Hive

```dart
// Registro de adaptadores
Hive.registerAdapter(CategoryAdapter());
Hive.registerAdapter(GameHistoryAdapter());
Hive.registerAdapter(DurationAdapter());

// Apertura de cajas de datos
await Hive.openBox<Category>('categories');
await Hive.openBox<GameHistory>('game_history');
```

## 🚀 Optimizaciones de Rendimiento

### 1. Lazy Loading

- Carga de categorías bajo demanda
- Inicialización diferida de servicios

### 2. Memory Management

- Disposición correcta de recursos de audio
- Limpieza de listeners de Provider

### 3. UI Optimization

- Widgets const donde sea posible
- Separación de widgets complejos

## 🧪 Testabilidad

### 1. Separación de Lógica

- Lógica de negocio en servicios
- UI separada de lógica de datos

### 2. Inyección de Dependencias

- Servicios inyectables para testing
- Mocks fáciles de implementar

### 3. Widget Testing

- Widgets modulares y testables
- Separación de responsabilidades

## 🔮 Escalabilidad

### 1. Modularidad

- Servicios independientes
- Pantallas modulares

### 2. Extensibilidad

- Fácil adición de nuevas categorías
- Sistema de plugins para funcionalidades

### 3. Mantenibilidad

- Código bien documentado
- Patrones consistentes

## 📊 Métricas de Calidad

- **Cobertura de código**: Objetivo >80%
- **Complejidad ciclomática**: <10 por método
- **Líneas por archivo**: <300 líneas
- **Acoplamiento**: Bajo entre módulos

---

**Siguiente**: [Estructura de Directorios](./directory-structure.md) | [Patrones de Diseño](./design-patterns.md)
