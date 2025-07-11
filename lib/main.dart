import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback and SystemChrome
import 'package:provider/provider.dart'; // For State Management
import 'package:what/core/color.dart';
import 'package:what/src/screens/categories/category_selection_screen.dart';
import 'package:what/src/screens/categories/create_custom_category_screen.dart';
import 'package:what/src/screens/game/countdiwn_screen.dart';
import 'package:what/src/screens/game/game_over_screen.dart';
import 'package:what/src/screens/game/game_setup_screen.dart';
import 'package:what/src/screens/game/gameplay_screen.dart';
import 'package:what/src/screens/game/how_to_play_screen.dart';
import 'package:what/src/screens/home/home_screen.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/orientation_manager.dart'; // For iOS-style timer

void main() {
  // Ensure Flutter binding is initialized before setting preferred orientations
  WidgetsFlutterBinding.ensureInitialized();
  // Start with unlocked orientation
  OrientationManager.unlockOrientation().then((_) {
    runApp(const TempoApp());
  });
}

// --- Main Application Widget ---
class TempoApp extends StatelessWidget {
  const TempoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameSettings(),
      child: MaterialApp(
        title: 'Tempo',
        debugShowCheckedModeBanner: false, // Hide debug banner
        themeMode: ThemeMode.system, // Use system theme
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kLightPrimary,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: kLightPrimary,
            onPrimary: Colors.white,
            secondary: kLightSecondary,
            onSecondary: Colors.white,
            error: Colors.redAccent,
            onError: Colors.white,
            surface: kLightSurface,
            onSurface: kLightOnSurface,
          ),
          scaffoldBackgroundColor: kLightBackground,
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 84.0,
              fontWeight: FontWeight.w900,
              color: kLightPrimary,
            ),
            headlineMedium: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: kLightSecondary,
            ),
            titleLarge: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
            labelLarge: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kLightSecondary, // Red
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kLightPrimary, // Blue
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: kDarkPrimary,
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: kDarkPrimary,
            onPrimary: Colors.white,
            secondary: kDarkSecondary,
            onSecondary: Colors.white,
            error: Colors.redAccent,
            onError: Colors.white,
            surface: kDarkSurface,
            onSurface: kDarkOnSurface,
          ),
          scaffoldBackgroundColor: kDarkBackground,
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 84.0,
              fontWeight: FontWeight.w900,
              color: kDarkPrimary,
            ),
            headlineMedium: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: kDarkSecondary,
            ),
            titleLarge: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
            labelLarge: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkSecondary, // Red
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kDarkPrimary, // Blue
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: kDarkSurface,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/categorySelection': (context) => CategorySelectionScreen(),
          '/createCategory': (context) => const CreateCustomCategoryScreen(),
          '/gameSetup': (context) => const GameSetupScreen(),
          '/howToPlay': (context) => const HowToPlayScreen(),
          '/countdown': (context) => const CountdownScreen(),
          '/gameplay': (context) => GameplayScreen(),
          '/gameOver': (context) => const GameOverScreen(),
        },
      ),
    );
  }
}
