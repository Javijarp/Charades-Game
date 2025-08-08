import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback and SystemChrome
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // For State Management
import 'package:what/core/color.dart';
import 'package:what/src/models/category.dart';
import 'package:what/src/models/game_history.dart';
import 'package:what/src/models/duration_adapter.dart';
import 'package:what/src/screens/categories/category_selection_screen.dart';
import 'package:what/src/screens/categories/create_custom_category_screen.dart';
import 'package:what/src/screens/categories/more_categories_screen.dart';
import 'package:what/src/screens/game/countdown_screen.dart';
import 'package:what/src/screens/game/game_over_screen.dart';
import 'package:what/src/screens/game/game_setup_screen.dart';
import 'package:what/src/screens/game/gameplay_screen.dart';
import 'package:what/src/screens/game/history_screen.dart';
import 'package:what/src/screens/game/how_to_play_screen.dart';
import 'package:what/src/screens/home/home_screen.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/orientation_manager.dart'; // For iOS-style timer
import 'package:what/src/services/category_service.dart';

void main() async {
  // Ensure Flutter binding is initialized before setting preferred orientations
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

  CustomCategoryService().addPredefinedCategories();

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
      create: (context) {
        final settings = GameSettings();
        settings.init();
        return settings;
      },
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
          useMaterial3: true,
          primaryColor: kDarkPrimary,
          scaffoldBackgroundColor: kDarkBackground,
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: kDarkPrimary,
            onPrimary: Colors.black,
            secondary: kDarkSecondary,
            onSecondary: Colors.black,
            error: Colors.redAccent,
            onError: Colors.white,
            surface: kDarkSurface,
            onSurface: kDarkOnSurface,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: kDarkSurface,
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          cardTheme: CardThemeData(
            color: kDarkSurface,
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 84.0,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
            titleLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(38, 50, 56, 1),
            ),
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white70),
            labelLarge: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkSecondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 5,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kDarkPrimary,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: Color(0xFF2A2D36),
            iconColor: Colors.white70,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/categorySelection': (context) => CategorySelectionScreen(),
          '/categories': (context) => CategorySelectionScreen(),
          '/createCategory': (context) => const CreateCustomCategoryScreen(),
          '/gameSetup': (context) => const GameSetupScreen(),
          '/howToPlay': (context) => const HowToPlayScreen(),
          '/countdown': (context) => const CountdownScreen(),
          '/gameplay': (context) => GameplayScreen(),
          '/gameOver': (context) => const GameOverScreen(),
          '/moreCategories': (context) => const MoreCategoriesScreen(),
          '/history': (context) => const HistoryScreen(),
        },
      ),
    );
  }
}
