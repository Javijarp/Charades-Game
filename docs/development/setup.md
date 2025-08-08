# 💻 Configuración del Proyecto - Tempo

## 🎯 Requisitos Previos

### Herramientas Necesarias

#### 1. Flutter SDK

- **Versión**: 3.8.1 o superior
- **Descarga**: [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Verificación**: `flutter --version`

#### 2. Dart SDK

- **Versión**: 3.0.0 o superior
- **Incluido**: Con la instalación de Flutter
- **Verificación**: `dart --version`

#### 3. IDE Recomendado

- **VS Code**: Con extensiones de Flutter y Dart
- **Android Studio**: Con plugin de Flutter
- **IntelliJ IDEA**: Con plugin de Flutter

#### 4. Herramientas de Desarrollo

- **Git**: Control de versiones
- **Android Studio**: Para desarrollo Android
- **Xcode**: Para desarrollo iOS (solo macOS)

## 🚀 Configuración Inicial

### 1. Clonar el Repositorio

```bash
# Clonar el repositorio
git clone [URL_DEL_REPOSITORIO]
cd App

# Verificar que estás en la rama correcta
git branch
```

### 2. Verificar Flutter

```bash
# Verificar instalación de Flutter
flutter doctor

# Resolver problemas si los hay
flutter doctor --android-licenses
```

### 3. Instalar Dependencias

```bash
# Obtener dependencias del proyecto
flutter pub get

# Verificar que no hay conflictos
flutter pub deps
```

### 4. Configurar Dispositivos

#### Android

```bash
# Verificar dispositivos Android conectados
flutter devices

# O iniciar un emulador
flutter emulators --launch <emulator_id>
```

#### iOS (solo macOS)

```bash
# Instalar dependencias de CocoaPods
cd ios
pod install
cd ..

# Verificar dispositivos iOS
flutter devices
```

## 🔧 Configuración del Entorno

### 1. Configuración de VS Code

#### Extensiones Recomendadas

```json
{
  "recommendations": [
    "Dart-Code.dart-code",
    "Dart-Code.flutter",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss"
  ]
}
```

#### Configuración de Workspace

```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  }
}
```

### 2. Configuración de Git

#### Hooks de Pre-commit

```bash
# Crear archivo .git/hooks/pre-commit
#!/bin/sh
flutter analyze
flutter test
```

#### Configuración de .gitignore

```gitignore
# Flutter/Dart specific
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
*.lock

# Android
android/gradle-wrapper.jar
android/.gradle
android/captures/
android/gradlew
android/gradlew.bat
android/local.properties
android/GeneratedPluginRegistrant.java

# iOS
ios/Pods/
ios/Runner.xcworkspace/xcshareddata/
ios/Runner.xcworkspace/xcuserdata/
ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/
ios/Runner.xcodeproj/project.xcworkspace/xcuserdata/
ios/Runner.xcodeproj/xcuserdata/

# IDE
.vscode/
.idea/
*.iml
```

## 🏗️ Estructura del Proyecto

### 1. Configuración de Build

#### pubspec.yaml

```yaml
name: what
description: "A new Flutter project."
publish_to: "none"
version: 0.1.0

environment:
  sdk: ^3.8.1

dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.11
  sensors_plus: ^3.0.0
  flutter_slidable: ^4.0.0
  audioplayers: ^5.2.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  provider: 6.1.5
  hive_generator: ^2.0.0
  build_runner: ^2.3.3
  flutter_launcher_icons: ^0.13.1
```

#### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - constant_identifier_names
    - control_flow_in_finally
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - library_prefixes
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_const_constructors
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_typing_uninitialized_variables
    - slash_for_doc_comments
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_statements
    - unrelated_type_equality_checks
    - use_rethrow_when_possible
    - valid_regexps
```

### 2. Configuración de Hive

#### Generación de Código

```bash
# Generar código para Hive
flutter packages pub run build_runner build

# O para desarrollo continuo
flutter packages pub run build_runner watch
```

#### Configuración en main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(GameHistoryAdapter());
  Hive.registerAdapter(DurationAdapter());

  if (!Hive.isBoxOpen('categories')) {
    await Hive.openBox<Category>('categories');
  }
  if (!Hive.isBoxOpen('game_history')) {
    await Hive.openBox<GameHistory>('game_history');
  }

  runApp(const TempoApp());
}
```

## 🧪 Testing

### 1. Configuración de Tests

#### Estructura de Tests

```
test/
├── unit/                    # Tests unitarios
│   ├── models/
│   ├── services/
│   └── widgets/
├── integration/             # Tests de integración
└── widget/                  # Tests de widgets
```

#### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/unit/models/category_test.dart

# Con cobertura
flutter test --coverage
```

### 2. Ejemplo de Test Unitario

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:what/src/models/category.dart';

void main() {
  group('Category Model Tests', () {
    test('should create category with correct properties', () {
      final category = Category(
        name: 'Test Category',
        words: ['word1', 'word2'],
        isCustom: true,
      );

      expect(category.name, 'Test Category');
      expect(category.words, ['word1', 'word2']);
      expect(category.isCustom, true);
    });
  });
}
```

## 🚀 Comandos de Desarrollo

### 1. Comandos Básicos

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Hot reload
r

# Hot restart
R

# Quit
q
```

### 2. Comandos de Build

```bash
# Build para Android
flutter build apk

# Build para iOS
flutter build ios

# Build para web
flutter build web
```

### 3. Comandos de Análisis

```bash
# Análisis estático
flutter analyze

# Formatear código
flutter format .

# Verificar dependencias
flutter pub deps
```

## 🔍 Debugging

### 1. Configuración de Debug

```dart
// En main.dart para desarrollo
void main() async {
  if (kDebugMode) {
    print('Running in debug mode');
  }
  // ... resto del código
}
```

### 2. Logging

```dart
import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message) {
    if (kDebugMode) {
      print('Tempo: $message');
    }
  }
}
```

### 3. Debugging con VS Code

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Tempo Debug",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart"
    }
  ]
}
```

## 📱 Configuración de Plataformas

### Android

```bash
# Verificar configuración Android
flutter doctor --android-licenses

# Configurar emulador
flutter emulators --create --name pixel_api_30
flutter emulators --launch pixel_api_30
```

### iOS (solo macOS)

```bash
# Instalar CocoaPods
sudo gem install cocoapods

# Configurar proyecto iOS
cd ios
pod install
cd ..
```

## 🔧 Configuración de CI/CD

### GitHub Actions

```yaml
name: Flutter CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.8.1"
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk
```

## 🚨 Solución de Problemas

### Problemas Comunes

#### 1. Dependencias Conflictivas

```bash
# Limpiar cache
flutter clean
flutter pub get
```

#### 2. Problemas de Build

```bash
# Limpiar build
flutter clean
flutter pub get
flutter run
```

#### 3. Problemas de Hive

```bash
# Regenerar código
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

#### 4. Problemas de iOS

```bash
cd ios
pod deintegrate
pod install
cd ..
```

## 📚 Recursos Adicionales

### Documentación

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Hive Documentation](https://docs.hivedb.dev/)

### Herramientas Útiles

- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Flutter Performance](https://flutter.dev/docs/perf/ui-performance)

---

**Siguiente**: [Dependencias y Librerías](./dependencies.md) | [Modelos de Datos](./data-models.md)
