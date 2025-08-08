# 🎨 Sistema de Colores - Tempo

## 🎯 Visión General

El sistema de colores de Tempo está diseñado para proporcionar una experiencia visual coherente y accesible, con soporte completo para temas claro y oscuro. Los colores están organizados en un sistema de tokens que facilita la consistencia y mantenimiento.

## 🌈 Paleta de Colores

### Colores Primarios

#### Modo Claro

```dart
// Colores principales para modo claro
const Color kLightPrimary = Color(0xFF2196F3);    // Azul principal
const Color kLightSecondary = Color(0xFFF44336);  // Rojo secundario
const Color kLightBackground = Color(0xFFF5F5F5); // Fondo gris claro
const Color kLightSurface = Color(0xFFFFFFFF);    // Superficie blanca
const Color kLightOnSurface = Color(0xFF000000);  // Texto sobre superficie
```

#### Modo Oscuro

```dart
// Colores principales para modo oscuro
const Color kDarkPrimary = Color(0xFF64B5F6);     // Azul claro
const Color kDarkSecondary = Color(0xFFEF5350);   // Rojo claro
const Color kDarkBackground = Color(0xFF121212);  // Fondo negro
const Color kDarkSurface = Color(0xFF1E1E1E);     // Superficie gris oscuro
const Color kDarkOnSurface = Color(0xFFFFFFFF);   // Texto sobre superficie
```

### Colores Semánticos

#### Estados y Feedback

```dart
// Colores para estados de la aplicación
const Color kSuccess = Color(0xFF4CAF50);         // Verde - éxito
const Color kWarning = Color(0xFFFF9800);         // Naranja - advertencia
const Color kError = Color(0xFFF44336);           // Rojo - error
const Color kInfo = Color(0xFF2196F3);            // Azul - información

// Colores para interacciones
const Color kHover = Color(0xFFE3F2FD);           // Hover azul claro
const Color kPressed = Color(0xFFBBDEFB);         // Presionado azul
const Color kDisabled = Color(0xFFBDBDBD);        // Deshabilitado gris
```

### Colores de Texto

#### Jerarquía Tipográfica

```dart
// Colores de texto para modo claro
const Color kTextPrimary = Color(0xFF000000);     // Texto principal
const Color kTextSecondary = Color(0xFF757575);   // Texto secundario
const Color kTextHint = Color(0xFFBDBDBD);        // Texto de sugerencia
const Color kTextDisabled = Color(0xFFE0E0E0);    // Texto deshabilitado

// Colores de texto para modo oscuro
const Color kTextPrimaryDark = Color(0xFFFFFFFF); // Texto principal
const Color kTextSecondaryDark = Color(0xFFBDBDBD); // Texto secundario
const Color kTextHintDark = Color(0xFF757575);    // Texto de sugerencia
const Color kTextDisabledDark = Color(0xFF424242); // Texto deshabilitado
```

## 🎨 Implementación en el Código

### Archivo de Configuración

```dart
// lib/core/color.dart
import 'package:flutter/material.dart';

// Colores para modo claro
const Color kLightPrimary = Color(0xFF2196F3);
const Color kLightSecondary = Color(0xFFF44336);
const Color kLightBackground = Color(0xFFF5F5F5);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightOnSurface = Color(0xFF000000);

// Colores para modo oscuro
const Color kDarkPrimary = Color(0xFF64B5F6);
const Color kDarkSecondary = Color(0xFFEF5350);
const Color kDarkBackground = Color(0xFF121212);
const Color kDarkSurface = Color(0xFF1E1E1E);
const Color kDarkOnSurface = Color(0xFFFFFFFF);

// Colores semánticos
const Color kSuccess = Color(0xFF4CAF50);
const Color kWarning = Color(0xFFFF9800);
const Color kError = Color(0xFFF44336);
const Color kInfo = Color(0xFF2196F3);

// Colores de interacción
const Color kHover = Color(0xFFE3F2FD);
const Color kPressed = Color(0xFFBBDEFB);
const Color kDisabled = Color(0xFFBDBDBD);
```

### Uso en Temas

```dart
// Configuración de tema claro
ThemeData(
  brightness: Brightness.light,
  primaryColor: kLightPrimary,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: kLightPrimary,
    onPrimary: Colors.white,
    secondary: kLightSecondary,
    onSecondary: Colors.white,
    error: kError,
    onError: Colors.white,
    surface: kLightSurface,
    onSurface: kLightOnSurface,
  ),
  scaffoldBackgroundColor: kLightBackground,
)

// Configuración de tema oscuro
ThemeData(
  brightness: Brightness.dark,
  primaryColor: kDarkPrimary,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: kDarkPrimary,
    onPrimary: Colors.black,
    secondary: kDarkSecondary,
    onSecondary: Colors.black,
    error: kError,
    onError: Colors.white,
    surface: kDarkSurface,
    onSurface: kDarkOnSurface,
  ),
  scaffoldBackgroundColor: kDarkBackground,
)
```

## 🎯 Aplicación por Componentes

### Botones

```dart
// Botón primario
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
  ),
  onPressed: () {},
  child: Text('START GAME'),
)

// Botón secundario
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
  ),
  onPressed: () {},
  child: Text('CATEGORIES'),
)
```

### Tarjetas

```dart
// Tarjeta con tema adaptativo
Card(
  color: Theme.of(context).colorScheme.surface,
  elevation: 8,
  child: ListTile(
    title: Text(
      'Category Name',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  ),
)
```

### Texto

```dart
// Texto con jerarquía
Text(
  'TEMPO',
  style: Theme.of(context).textTheme.displayLarge?.copyWith(
    color: Theme.of(context).colorScheme.onSurface,
  ),
)
```

## 🌙 Transición entre Temas

### Detección Automática

```dart
// En main.dart
MaterialApp(
  themeMode: ThemeMode.system, // Usa el tema del sistema
  theme: ThemeData(/* tema claro */),
  darkTheme: ThemeData(/* tema oscuro */),
)
```

### Cambio Manual

```dart
// Cambiar tema programáticamente
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
```

## ♿ Accesibilidad

### Contraste de Colores

```dart
// Verificar contraste
double contrastRatio = calculateContrastRatio(
  foregroundColor,
  backgroundColor
);

// Mínimo contraste recomendado: 4.5:1
bool isAccessible = contrastRatio >= 4.5;
```

### Colores para Daltonismo

```dart
// Usar patrones además de colores
Container(
  decoration: BoxDecoration(
    color: kSuccess,
    border: Border.all(color: Colors.black, width: 2),
  ),
  child: Icon(Icons.check, color: Colors.white),
)
```

## 📱 Adaptación por Plataforma

### Android

```dart
// Colores específicos de Material Design
const Color kAndroidPrimary = Color(0xFF6200EE);
const Color kAndroidSecondary = Color(0xFF03DAC6);
```

### iOS

```dart
// Colores específicos de iOS
const Color kiOSPrimary = Color(0xFF007AFF);
const Color kiOSSecondary = Color(0xFFFF3B30);
```

## 🎨 Herramientas de Diseño

### Generador de Paletas

```dart
// Generar variaciones de color
class ColorGenerator {
  static List<Color> generateShades(Color baseColor) {
    return [
      baseColor.withOpacity(0.1),
      baseColor.withOpacity(0.3),
      baseColor.withOpacity(0.5),
      baseColor.withOpacity(0.7),
      baseColor.withOpacity(0.9),
    ];
  }
}
```

### Validación de Colores

```dart
// Validar que los colores cumplen con estándares
class ColorValidator {
  static bool isValidContrast(Color foreground, Color background) {
    double contrast = calculateContrastRatio(foreground, background);
    return contrast >= 4.5;
  }

  static double calculateContrastRatio(Color foreground, Color background) {
    // Implementación del cálculo de contraste
    return 0.0; // Placeholder
  }
}
```

## 📊 Gestión de Colores

### Variables CSS (para web)

```css
:root {
  /* Colores primarios */
  --tempo-primary: #2196f3;
  --tempo-secondary: #f44336;
  --tempo-background: #f5f5f5;
  --tempo-surface: #ffffff;

  /* Colores semánticos */
  --tempo-success: #4caf50;
  --tempo-warning: #ff9800;
  --tempo-error: #f44336;
  --tempo-info: #2196f3;
}

[data-theme="dark"] {
  --tempo-primary: #64b5f6;
  --tempo-secondary: #ef5350;
  --tempo-background: #121212;
  --tempo-surface: #1e1e1e;
}
```

### Tokens de Diseño

```json
{
  "colors": {
    "primary": {
      "light": "#2196F3",
      "dark": "#64B5F6"
    },
    "secondary": {
      "light": "#F44336",
      "dark": "#EF5350"
    },
    "background": {
      "light": "#F5F5F5",
      "dark": "#121212"
    },
    "surface": {
      "light": "#FFFFFF",
      "dark": "#1E1E1E"
    }
  }
}
```

## 🔄 Migración y Actualización

### Proceso de Actualización

1. **Identificar colores obsoletos**
2. **Crear nuevos tokens**
3. **Actualizar componentes**
4. **Validar accesibilidad**
5. **Probar en ambos temas**

### Versionado de Colores

```dart
// Versión 1.0
const Color kPrimaryV1 = Color(0xFF2196F3);

// Versión 2.0 (nuevo color)
const Color kPrimaryV2 = Color(0xFF1976D2);

// Mantener compatibilidad
const Color kPrimary = kPrimaryV2; // Usar la versión más reciente
```

---

**Siguiente**: [Tipografía](./typography.md) | [Componentes UI](./ui-components.md)
