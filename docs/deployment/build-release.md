# 🚀 Build y Release - Tempo

## 🎯 Visión General

Esta guía detalla el proceso completo de build y release de la aplicación Tempo para las plataformas Android e iOS, incluyendo configuración, optimización y distribución.

## 📱 Configuración de Build

### 1. Configuración de Android

#### build.gradle.kts (App Level)

```kotlin
android {
    namespace = "com.example.what"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.what"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "0.1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            isDebuggable = true
            applicationIdSuffix = ".debug"
        }
    }

    signingConfigs {
        create("release") {
            storeFile = file("keystore/release-key.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
}
```

#### AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="Tempo"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:allowBackup="true"
        android:fullBackupContent="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>

    <!-- Permisos necesarios -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
</manifest>
```

### 2. Configuración de iOS

#### Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>Tempo</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>what</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <false/>
    <key>CADisableMinimumFrameDurationOnPhone</key>
    <true/>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
</dict>
</plist>
```

#### Podfile

```ruby
platform :ios, '11.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    # Configuración adicional para iOS
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

## 🔐 Configuración de Firma

### 1. Android Keystore

#### Generar Keystore

```bash
# Generar keystore para release
keytool -genkey -v -keystore android/app/keystore/release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release-key \
  -storepass your_keystore_password \
  -keypass your_key_password
```

#### Configurar Variables de Entorno

```bash
# .env file (no commit to git)
KEYSTORE_PASSWORD=your_keystore_password
KEY_ALIAS=release-key
KEY_PASSWORD=your_key_password
```

### 2. iOS Code Signing

#### Certificados de Desarrollo

```bash
# Instalar certificados de desarrollo
security import development.p12 -k ~/Library/Keychains/login.keychain
security import distribution.p12 -k ~/Library/Keychains/login.keychain
```

#### Provisioning Profiles

- Descargar perfiles de aprovisionamiento desde Apple Developer Portal
- Colocar en `~/Library/MobileDevice/Provisioning Profiles/`

## 🏗️ Comandos de Build

### 1. Build de Desarrollo

#### Android Debug

```bash
# Build debug para Android
flutter build apk --debug

# Build debug para Android con análisis
flutter build apk --debug --analyze-size
```

#### iOS Debug

```bash
# Build debug para iOS
flutter build ios --debug

# Build debug para iOS simulador
flutter build ios --debug --simulator
```

### 2. Build de Release

#### Android Release

```bash
# Build release APK
flutter build apk --release

# Build release App Bundle (recomendado para Play Store)
flutter build appbundle --release

# Build release con análisis de tamaño
flutter build apk --release --analyze-size
```

#### iOS Release

```bash
# Build release para iOS
flutter build ios --release

# Build para archivo IPA
flutter build ipa --release
```

### 3. Build Multiplataforma

```bash
# Build para todas las plataformas
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

## 📊 Optimización de Build

### 1. Optimización de Android

#### ProGuard Rules

```proguard
# proguard-rules.pro
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Hive
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }
-keep class * implements androidx.sqlite.db.SupportSQLiteOpenHelper { *; }

# AudioPlayers
-keep class com.luanpotter.audioplayers.** { *; }
```

#### Optimización de Recursos

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/sounds/
    - assets/icon/

  # Optimizar imágenes
  uses-material-design: true
```

### 2. Optimización de iOS

#### Configuración de Xcode

```bash
# Habilitar optimizaciones
flutter build ios --release --no-codesign
```

#### Optimización de Assets

```bash
# Comprimir imágenes
flutter build ios --release --tree-shake-icons
```

## 🧪 Testing de Build

### 1. Testing Automatizado

```bash
# Ejecutar tests antes del build
flutter test

# Testing de integración
flutter drive --target=test_driver/app.dart
```

### 2. Testing Manual

```bash
# Instalar APK en dispositivo
flutter install

# Instalar en simulador iOS
flutter install --debug
```

## 📦 Distribución

### 1. Google Play Store

#### Preparar Release

```bash
# Generar App Bundle
flutter build appbundle --release

# Firmar App Bundle
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore android/app/keystore/release-key.jks \
  build/app/outputs/bundle/release/app-release.aab \
  release-key
```

#### Subir a Play Console

1. Ir a [Google Play Console](https://play.google.com/console)
2. Crear nueva aplicación
3. Subir App Bundle (.aab)
4. Completar información de la aplicación
5. Configurar precios y distribución
6. Enviar para revisión

### 2. Apple App Store

#### Preparar Release

```bash
# Generar IPA
flutter build ipa --release

# O usar Xcode
open ios/Runner.xcworkspace
```

#### Subir a App Store Connect

1. Ir a [App Store Connect](https://appstoreconnect.apple.com)
2. Crear nueva aplicación
3. Subir build usando Xcode o Application Loader
4. Completar información de la aplicación
5. Configurar precios y distribución
6. Enviar para revisión

### 3. Distribución Interna

#### Android

```bash
# Generar APK para distribución interna
flutter build apk --release

# Compartir archivo APK
# Ubicación: build/app/outputs/flutter-apk/app-release.apk
```

#### iOS

```bash
# Generar IPA para TestFlight
flutter build ipa --release

# Subir a TestFlight
# Usar Xcode o Application Loader
```

## 🔄 CI/CD Pipeline

### 1. GitHub Actions

```yaml
name: Build and Release

on:
  push:
    tags:
      - "v*"

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.8.1"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build APK
        run: flutter build apk --release

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: android-release
          path: build/app/outputs/

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.8.1"

      - name: Install dependencies
        run: flutter pub get

      - name: Build iOS
        run: flutter build ios --release --no-codesign

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ios-release
          path: build/ios/
```

### 2. Fastlane (Opcional)

```ruby
# fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy to Play Store"
  lane :deploy do
    gradle(
      task: "clean assembleRelease",
      project_dir: "android/"
    )
    upload_to_play_store(
      track: 'internal'
    )
  end
end

platform :ios do
  desc "Deploy to TestFlight"
  lane :deploy do
    build_ios_app(
      scheme: "Runner",
      export_method: "app-store"
    )
    upload_to_testflight
  end
end
```

## 📈 Monitoreo de Release

### 1. Analytics

```dart
// Configurar analytics en la aplicación
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static void logAppOpen() {
    _analytics.logAppOpen();
  }

  static void logGameStart(String category) {
    _analytics.logEvent(
      name: 'game_start',
      parameters: {'category': category},
    );
  }
}
```

### 2. Crash Reporting

```dart
// Configurar crash reporting
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const TempoApp());
}
```

## 🚨 Solución de Problemas

### Problemas Comunes

#### Build Fails

```bash
# Limpiar build
flutter clean
flutter pub get

# Verificar dependencias
flutter doctor
```

#### Signing Issues

```bash
# Verificar keystore
keytool -list -v -keystore android/app/keystore/release-key.jks

# Verificar certificados iOS
security find-identity -v -p codesigning
```

#### Size Issues

```bash
# Analizar tamaño
flutter build apk --analyze-size

# Optimizar assets
flutter build apk --tree-shake-icons
```

---

**Siguiente**: [Configuración de Iconos](./app-icons.md) | [Plataformas](./../platforms/android.md)
