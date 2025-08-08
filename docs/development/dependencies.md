# 📦 Dependencias y Librerías - Tempo

## 🎯 Visión General

Tempo utiliza un conjunto cuidadosamente seleccionado de dependencias para proporcionar funcionalidades robustas y mantener un rendimiento óptimo. Esta documentación detalla cada dependencia, su propósito y configuración.

## 📋 Dependencias Principales

### 🗄️ Almacenamiento de Datos

#### Hive

```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
```

**Propósito**: Base de datos NoSQL local para persistencia de datos.

**Funcionalidades**:

- Almacenamiento de categorías personalizadas
- Historial de partidas
- Configuraciones de usuario
- Sincronización offline

**Configuración**:

```dart
// Inicialización en main.dart
await Hive.initFlutter();
Hive.registerAdapter(CategoryAdapter());
Hive.registerAdapter(GameHistoryAdapter());
Hive.registerAdapter(DurationAdapter());

// Apertura de cajas
await Hive.openBox<Category>('categories');
await Hive.openBox<GameHistory>('game_history');
```

**Uso en el proyecto**:

- `CategoryService`: Gestión de categorías
- `GameHistoryService`: Historial de partidas
- Modelos: `Category`, `GameHistory`

#### Path Provider

```yaml
path_provider: ^2.0.11
```

**Propósito**: Acceso a directorios del sistema de archivos.

**Funcionalidades**:

- Directorio de documentos
- Directorio temporal
- Directorio de caché

**Uso**:

```dart
import 'package:path_provider/path_provider.dart';

// Obtener directorio de documentos
Directory documentsDir = await getApplicationDocumentsDirectory();
```

### 🎵 Audio y Multimedia

#### AudioPlayers

```yaml
audioplayers: ^5.2.1
```

**Propósito**: Reproducción de efectos de sonido durante el juego.

**Funcionalidades**:

- Efectos de sonido para aciertos
- Sonidos de cuenta regresiva
- Audio de fondo (futuro)

**Configuración**:

```dart
// Reproducir sonido
AudioPlayer audioPlayer = AudioPlayer();
await audioPlayer.play(AssetSource('sounds/correct.mp3'));
```

**Archivos de audio incluidos**:

- `correct.mp3`: Sonido de acierto
- `pass.mp3`: Sonido al pasar palabra
- `copper-bell-ding-23-215438.mp3`: Sonido de campana
- `rightanswer-95219.mp3`: Sonido de respuesta correcta
- `successed-295058.mp3`: Sonido de éxito

### 📱 Sensores y Hardware

#### Sensors Plus

```yaml
sensors_plus: ^3.0.0
```

**Propósito**: Acceso a sensores del dispositivo.

**Funcionalidades**:

- Detección de movimiento
- Orientación del dispositivo
- Acelerómetro (futuras funcionalidades)

**Uso**:

```dart
import 'package:sensors_plus/sensors_plus.dart';

// Escuchar cambios de orientación
accelerometerEvents.listen((AccelerometerEvent event) {
  // Procesar datos del acelerómetro
});
```

### 🎨 Interfaz de Usuario

#### Flutter Slidable

```yaml
flutter_slidable: ^4.0.0
```

**Propósito**: Widgets deslizables para acciones en listas.

**Funcionalidades**:

- Eliminar categorías con deslizamiento
- Acciones rápidas en historial
- Gestos intuitivos

**Uso**:

```dart
Slidable(
  endActionPane: ActionPane(
    motion: const ScrollMotion(),
    children: [
      SlidableAction(
        onPressed: (context) => deleteCategory(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      ),
    ],
  ),
  child: ListTile(title: Text('Category Name')),
)
```

### 🌍 Internacionalización

#### Intl

```yaml
intl: ^0.18.1
```

**Propósito**: Formateo de fechas, números y localización.

**Funcionalidades**:

- Formateo de fechas en historial
- Localización de textos
- Formateo de números

**Uso**:

```dart
import 'package:intl/intl.dart';

// Formatear fecha
String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

// Formatear duración
String formattedDuration = DateFormat('mm:ss').format(duration);
```

## 🔧 Dependencias de Desarrollo

### 🧪 Testing

#### Flutter Test

```yaml
flutter_test:
  sdk: flutter
```

**Propósito**: Framework de testing para Flutter.

**Configuración**:

```dart
// Ejemplo de test
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Category selection test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Categories'), findsOneWidget);
  });
}
```

### 📏 Linting y Análisis

#### Flutter Lints

```yaml
flutter_lints: ^5.0.0
```

**Propósito**: Reglas de linting para mantener calidad de código.

**Configuración**:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - prefer_const_constructors
    - prefer_final_fields
```

### 🏗️ Generación de Código

#### Build Runner

```yaml
build_runner: ^2.3.3
```

**Propósito**: Generación automática de código.

**Uso**:

```bash
# Generar código una vez
flutter packages pub run build_runner build

# Generar código en modo watch
flutter packages pub run build_runner watch
```

#### Hive Generator

```yaml
hive_generator: ^2.0.0
```

**Propósito**: Generación de adaptadores para Hive.

**Uso**:

```dart
// En modelos
@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> words;
}
```

### 🎨 Iconos de la Aplicación

#### Flutter Launcher Icons

```yaml
flutter_launcher_icons: ^0.13.1
```

**Propósito**: Generación automática de iconos para la aplicación.

**Configuración**:

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true
```

**Uso**:

```bash
# Generar iconos
flutter pub run flutter_launcher_icons:main
```

### 🎯 Gestión de Estado

#### Provider

```yaml
provider: 6.1.5
```

**Propósito**: Gestión de estado de la aplicación.

**Configuración**:

```dart
// En main.dart
ChangeNotifierProvider(
  create: (context) => GameSettings(),
  child: MaterialApp(
    // ...
  ),
)
```

**Uso**:

```dart
// En widgets
final gameSettings = Provider.of<GameSettings>(context);
// O
final gameSettings = context.read<GameSettings>();
```

## 📊 Análisis de Dependencias

### Tamaño de la Aplicación

```bash
# Analizar tamaño de dependencias
flutter build apk --analyze-size

# Ver dependencias transitivas
flutter pub deps
```

### Conflictos de Versiones

```bash
# Verificar conflictos
flutter pub deps --style=tree

# Resolver conflictos
flutter pub upgrade
```

## 🔄 Actualización de Dependencias

### Proceso de Actualización

1. **Verificar actualizaciones disponibles**

   ```bash
   flutter pub outdated
   ```

2. **Actualizar dependencias**

   ```bash
   flutter pub upgrade
   ```

3. **Verificar compatibilidad**

   ```bash
   flutter test
   flutter analyze
   ```

4. **Probar en dispositivos**
   ```bash
   flutter run
   ```

### Política de Versiones

- **Dependencias principales**: Versiones específicas para estabilidad
- **Dependencias de desarrollo**: Rangos de versiones para flexibilidad
- **Actualizaciones**: Mensuales con testing exhaustivo

## 🚨 Solución de Problemas

### Problemas Comunes

#### Conflictos de Versiones

```bash
# Limpiar cache
flutter clean
flutter pub get

# Forzar resolución
flutter pub deps --style=tree
```

#### Problemas de Build

```bash
# Regenerar código
flutter packages pub run build_runner clean
flutter packages pub run build_runner build

# Limpiar build
flutter clean
flutter pub get
```

#### Problemas de Audio

```bash
# Verificar permisos
# Android: android/app/src/main/AndroidManifest.xml
# iOS: ios/Runner/Info.plist
```

### Logs de Debug

```dart
// Habilitar logs de Hive
Hive.initFlutter();
if (kDebugMode) {
  Hive.logger = HiveLogger();
}
```

## 📚 Recursos Adicionales

### Documentación Oficial

- [Hive Documentation](https://docs.hivedb.dev/)
- [AudioPlayers Documentation](https://pub.dev/packages/audioplayers)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Sensors Plus Documentation](https://pub.dev/packages/sensors_plus)

### Mejores Prácticas

- **Minimizar dependencias**: Solo incluir lo necesario
- **Versiones específicas**: Para dependencias críticas
- **Testing regular**: Verificar compatibilidad
- **Documentación**: Mantener actualizada

---

**Siguiente**: [Modelos de Datos](./data-models.md) | [Servicios y Lógica de Negocio](./services.md)
