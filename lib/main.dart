import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback and SystemChrome
import 'package:sensors_plus/sensors_plus.dart'; // For Gyroscope
import 'package:provider/provider.dart'; // For State Management
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'; // For iOS-style timer

// --- Orientation Management ---
class OrientationManager {
  static const List<DeviceOrientation> _allOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static const List<DeviceOrientation> _landscapeOnly = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static Future<void> unlockOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations(_allOrientations);
    } catch (e) {
      print('Error unlocking orientation: $e');
    }
  }

  static Future<void> lockToLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations(_landscapeOnly);
    } catch (e) {
      print('Error locking to landscape: $e');
    }
  }
}

// Mixin for screens that need to ensure unlocked orientation
mixin UnlockedOrientationMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    // Ensure orientation is unlocked when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrientationManager.unlockOrientation();
    });
  }
}

void main() {
  // Ensure Flutter binding is initialized before setting preferred orientations
  WidgetsFlutterBinding.ensureInitialized();
  // Start with unlocked orientation
  OrientationManager.unlockOrientation().then((_) {
    runApp(const TempoApp());
  });
}

// --- Data Models ---
class Category {
  final String name;
  final List<String> words;
  final bool isCustom;

  Category({required this.name, required this.words, this.isCustom = false});
}

// --- Game State Management ---
class GameSettings with ChangeNotifier {
  Category? _selectedCategory;
  final bool _firstTimePlaying = true;
  Duration _gameDuration = const Duration(
    minutes: 1,
    seconds: 30,
  ); // Default to 1:30
  int _correctAnswers = 0;
  int _passes = 0;
  final List<Category> _customCategories = []; // To store custom categories
  bool _isGameLandscapeMode =
      false; // Track if game is in landscape-locked mode

  Category? get selectedCategory => _selectedCategory;
  Duration get gameDuration => _gameDuration;
  int get correctAnswers => _correctAnswers;
  int get passes => _passes;
  List<Category> get customCategories => _customCategories;
  bool get isGameLandscapeMode => _isGameLandscapeMode;

  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setGameDuration(Duration duration) {
    _gameDuration = duration;
    notifyListeners();
  }

  void resetScore() {
    _correctAnswers = 0;
    _passes = 0;
    notifyListeners();
  }

  void incrementCorrect() {
    _correctAnswers++;
    notifyListeners();
  }

  void incrementPass() {
    _passes++;
    notifyListeners();
  }

  void addCustomCategory(Category category) {
    _customCategories.add(category);
    notifyListeners();
  }

  void setGameLandscapeMode(bool value) {
    _isGameLandscapeMode = value;
    notifyListeners();
  }
}

// --- Color Palette ---
const Color kLightBackground = Colors.white;
const Color kLightPrimary = Color(0xFF1565C0); // Blue
const Color kLightSecondary = Color(0xFFD32F2F); // Red
const Color kLightSurface = Colors.white;
const Color kLightOnSurface = Colors.black87;

const Color kDarkBackground = Color(0xFF181A20);
const Color kDarkPrimary = Color(0xFF42A5F5); // Lighter Blue
const Color kDarkSecondary = Color(0xFFFF5252); // Bright Red
const Color kDarkSurface = Color(0xFF23272F);
const Color kDarkOnSurface = Colors.white;

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

// --- Custom Widgets for consistent styling ---
class TempoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isPrimary;
  final IconData? icon;

  const TempoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (!isPrimary) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? colorScheme.primary, // Blue
          side: BorderSide(color: backgroundColor ?? colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colorScheme.secondary, // Red
        foregroundColor: foregroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// --- 1. Main Menu / Home Screen ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).colorScheme.primary.withOpacity(0.9), // Blue
          //     Theme.of(context).colorScheme.secondary.withOpacity(0.9), // Red
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TEMPO',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.blueGrey.shade900,
                  fontSize: 90,
                  letterSpacing: 5,
                ),
              ),
              const SizedBox(height: 20), // Increased spacing
              Text(
                'Charades Unleashed',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blueGrey.shade500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 80), // Increased spacing
              TempoButton(
                text: 'START GAME',
                onPressed: () {
                  final gameSettings = Provider.of<GameSettings>(
                    context,
                    listen: false,
                  );
                  if (gameSettings.selectedCategory == null) {
                    // Set a default category if none chosen
                    gameSettings.selectCategory(
                      Category(
                        name: 'Movies',
                        words: [
                          'Titanic',
                          'Avatar',
                          'Star Wars',
                          'Inception',
                          'Jaws',
                          'Lion King',
                        ],
                      ),
                    );
                  }
                  // After selecting/defaulting category, go to game setup
                  Navigator.pushNamed(context, '/categorySelection');
                },
                backgroundColor: Theme.of(context).colorScheme.secondary, // Red
              ),
              const SizedBox(height: 25),
              // Use Wrap for responsive button layout
              Wrap(
                spacing: 20,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  TempoButton(
                    text: 'CATEGORIES',
                    onPressed: () {
                      Navigator.pushNamed(context, '/categorySelection');
                    },
                    isPrimary: false,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, // Blue
                    icon: Icons.list_alt,
                  ),
                  TempoButton(
                    text: 'HOW TO PLAY',
                    onPressed: () {
                      Navigator.pushNamed(context, '/howToPlay');
                    },
                    isPrimary: false,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, // Blue
                    icon: Icons.help_outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Category Selection Screen ---
class CategorySelectionScreen extends StatelessWidget {
  final List<Category> predefinedCategories = [
    Category(
      name: 'Movies',
      words: const [
        'Titanic',
        'Avatar',
        'Star Wars',
        'Inception',
        'Jaws',
        'Lion King',
        'Forrest Gump',
        'The Matrix',
        'Pulp Fiction',
        'Spirited Away',
      ],
    ),
    Category(
      name: 'Animals',
      words: const [
        'Dog',
        'Cat',
        'Elephant',
        'Lion',
        'Giraffe',
        'Monkey',
        'Dolphin',
        'Tiger',
        'Panda',
        'Kangaroo',
      ],
    ),
    Category(
      name: 'Sports',
      words: const [
        'Basketball',
        'Soccer',
        'Tennis',
        'Swimming',
        'Baseball',
        'Golf',
        'Volleyball',
        'Boxing',
        'Skiing',
        'Cycling',
      ],
    ),
    Category(
      name: 'Food',
      words: const [
        'Pizza',
        'Burger',
        'Sushi',
        'Taco',
        'Ice Cream',
        'Spaghetti',
        'Chocolate',
        'Donut',
        'Salad',
        'Pancake',
      ],
    ),
    Category(
      name: 'Historical Figures',
      words: const [
        'George Washington',
        'Cleopatra',
        'Albert Einstein',
        'Leonardo da Vinci',
        'Marie Curie',
        'Martin Luther King Jr.',
        'Queen Elizabeth I',
        'Nelson Mandela',
        'Isaac Newton',
        'Joan of Arc',
      ],
    ),
    Category(
      name: 'Pop Culture',
      words: const [
        'Harry Potter',
        'Star Wars',
        'Beyoncé',
        'TikTok',
        'Emoji',
        'Marvel',
        'Game of Thrones',
        'Netflix',
        'Pokémon',
        'Fortnite',
      ],
    ),
  ];

  CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        Provider.of<GameSettings>(context).isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Category'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<GameSettings>(
        builder: (context, gameSettings, child) {
          final allCategories = [
            ...predefinedCategories,
            ...gameSettings.customCategories,
          ];

          if (isLandscape) {
            // Landscape layout: side-by-side
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      return Card(
                        color: Colors.white,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ), // Blue
                          ),
                          trailing:
                              gameSettings.selectedCategory?.name ==
                                  category.name
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  size: 30,
                                ) // Red
                              : null,
                          onTap: () {
                            gameSettings.selectCategory(category);
                            Navigator.pushNamed(context, '/gameSetup');
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TempoButton(
                          text: 'CREATE NEW',
                          onPressed: () {
                            Navigator.pushNamed(context, '/createCategory');
                          },
                          icon: Icons.add_circle_outline,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary, // Blue
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Choose from predefined categories or create your own!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.blueGrey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout: stacked
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      return Card(
                        color: Colors.white,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ), // Blue
                          ),
                          trailing:
                              gameSettings.selectedCategory?.name ==
                                  category.name
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  size: 30,
                                ) // Red
                              : null,
                          onTap: () {
                            gameSettings.selectCategory(category);
                            Navigator.pushNamed(context, '/gameSetup');
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TempoButton(
                        text: 'CREATE NEW',
                        onPressed: () {
                          Navigator.pushNamed(context, '/createCategory');
                        },
                        icon: Icons.add_circle_outline,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.tertiary, // Blue
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose from predefined categories or create your own!',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// --- 3. Create Custom Category Screen ---
class CreateCustomCategoryScreen extends StatefulWidget {
  const CreateCustomCategoryScreen({super.key});

  @override
  _CreateCustomCategoryScreenState createState() =>
      _CreateCustomCategoryScreenState();
}

class _CreateCustomCategoryScreenState extends State<CreateCustomCategoryScreen>
    with UnlockedOrientationMixin {
  final _categoryNameController = TextEditingController();
  final _wordListController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _categoryNameController.dispose();
    _wordListController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final categoryName = _categoryNameController.text.trim();
      final wordsString = _wordListController.text.trim();
      final words = wordsString
          .split(RegExp(r'[,;\n]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      if (words.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter at least one word for your category.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final newCategory = Category(
        name: categoryName,
        words: words,
        isCustom: true,
      );
      Provider.of<GameSettings>(
        context,
        listen: false,
      ).addCustomCategory(newCategory);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Category "${newCategory.name}" saved!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      Navigator.pop(context); // Go back to category selection
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        Provider.of<GameSettings>(context).isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Category'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 10,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isLandscape ? 600 : double.infinity,
              ),
              padding: EdgeInsets.all(isLandscape ? 20.0 : 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Define Your Category',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: isLandscape ? 24 : 30,
                            color: Theme.of(context).primaryColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isLandscape ? 20 : 30),
                    TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'e.g., 90s Throwback',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _wordListController,
                      maxLines: isLandscape ? 4 : 6,
                      decoration: InputDecoration(
                        labelText: 'Word List',
                        hintText:
                            'Enter words separated by commas or on new lines (e.g., \'Titanic, Spice Girls, Tamagotchi\')',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter at least one word.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isLandscape ? 30 : 40),
                    // Use Wrap for responsive button layout
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        TempoButton(
                          text: 'SAVE CATEGORY',
                          onPressed: _saveCategory,
                          icon: Icons.save,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary, // Red
                        ),
                        TempoButton(
                          text: 'CANCEL',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          isPrimary: false,
                          icon: Icons.cancel_outlined,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary, // Blue
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. Game Setup Screen ---
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  _GameSetupScreenState createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen>
    with UnlockedOrientationMixin {
  Duration _selectedLocalDuration = const Duration(minutes: 1, seconds: 30);

  @override
  void initState() {
    super.initState();
    // Initialize local duration from global state on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedLocalDuration = Provider.of<GameSettings>(
        context,
        listen: false,
      ).gameDuration;
      setState(() {}); // Rebuild to show initial duration
    });
  }

  void _showTimePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: const Text(
          'CONFIRM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        cancel: const Text('CANCEL', style: TextStyle(color: Colors.white70)),
        itemTextStyle: Theme.of(
          context,
        ).textTheme.headlineMedium!.copyWith(fontSize: 35),
        backgroundColor: Theme.of(context).cardColor,
      ),
      dateFormat: 'mm:ss',
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        _selectedLocalDuration.inMinutes,
        _selectedLocalDuration.inSeconds % 60,
      ),
      minDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
        10,
      ), // Min 10 seconds
      maxDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        5,
        0,
      ), // Max 5 minutes
      onConfirm: (dateTime, List<int> selectedIndex) {
        setState(() {
          _selectedLocalDuration = Duration(
            minutes: dateTime.minute,
            seconds: dateTime.second,
          );
        });
        Provider.of<GameSettings>(
          context,
          listen: false,
        ).setGameDuration(_selectedLocalDuration);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Time set to ${_selectedLocalDuration.inMinutes}m ${_selectedLocalDuration.inSeconds % 60}s.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Category:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: isLandscape ? 8 : 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to category selection
                },
                child: Text(
                  gameSettings.selectedCategory?.name ?? 'No Category Selected',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isLandscape ? 32 : 40,
                    color: Theme.of(context).colorScheme.primary, // Blue
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(
                      context,
                    ).colorScheme.tertiary, // Blue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isLandscape ? 20 : 30),
              Text(
                'Time per Round:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: isLandscape ? 8 : 10),
              GestureDetector(
                onTap: () => _showTimePicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 20 : 25,
                    vertical: isLandscape ? 12 : 15,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '${_selectedLocalDuration.inMinutes.toString().padLeft(2, '0')}:${(_selectedLocalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isLandscape ? 48 : 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isLandscape ? 30 : 40),
              TempoButton(
                text: 'START GAME',
                onPressed: gameSettings.selectedCategory != null
                    ? () {
                        gameSettings
                            .resetScore(); // Reset scores for a new game
                        Navigator.pushNamed(context, '/countdown');
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a category first.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                backgroundColor: gameSettings.selectedCategory != null
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey, // Red, disable if no category
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 5. Countdown Screen ---
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with UnlockedOrientationMixin {
  int _countdown = 3;
  // TODO: Initialize and use AudioPlayer for sounds

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      try {
        setState(() {
          _countdown--;
        });
        if (_countdown > 0) {
          _startCountdown();
        } else {
          if (mounted) {
            try {
              Navigator.pushReplacementNamed(context, '/gameplay');
            } catch (e) {
              print('Error navigating to gameplay: $e');
            }
          }
        }
      } catch (e) {
        print('Error in countdown: $e');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9), // Blue
              Theme.of(context).colorScheme.secondary.withOpacity(0.9), // Red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Use FittedBox to prevent overflow of the large countdown number
                  FittedBox(
                    fit: BoxFit.scaleDown, // Shrinks the text if needed
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                      child: Text(
                        _countdown.toString(),
                        key: ValueKey<int>(_countdown),
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: isLandscape ? 150 : 200,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: isLandscape ? 20 : 40),
                  Text(
                    'Get Ready!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white70,
                      fontSize: isLandscape ? 24 : 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isLandscape ? 15 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: isLandscape ? 35 : 50,
                            color: Theme.of(context).colorScheme.secondary,
                          ), // Red
                          Text(
                            'PASS',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontSize: isLandscape ? 16 : 20,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(width: isLandscape ? 30 : 50),
                      Column(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: isLandscape ? 35 : 50,
                            color: Theme.of(context).colorScheme.secondary,
                          ), // Red
                          Text(
                            'CORRECT',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontSize: isLandscape ? 16 : 20,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 6. Gameplay Screen ---
class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with SingleTickerProviderStateMixin {
  late final GameSettings _gameSettings;
  late List<String> _currentWords;
  late int _currentWordIndex;
  late int _remainingSeconds;
  late AnimationController _timerAnimationController;
  bool _waitedForOrientation = false;

  bool _isTiltDebounced = false; // For debouncing tilt input
  static const Duration _debounceDuration = Duration(milliseconds: 500);
  bool _gameEnded = false; // Prevent multiple game end triggers
  bool _resourcesDisposed = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await OrientationManager.lockToLandscape();
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) setState(() => _waitedForOrientation = true);
      Provider.of<GameSettings>(
        context,
        listen: false,
      ).setGameLandscapeMode(true);
    });

    try {
      _gameSettings = Provider.of<GameSettings>(context, listen: false);
      _currentWords = List.from(_gameSettings.selectedCategory!.words)
        ..shuffle(); // Shuffle words
      _currentWordIndex = 0;
      _remainingSeconds = _gameSettings.gameDuration.inSeconds;

      _timerAnimationController =
          AnimationController(vsync: this, duration: _gameSettings.gameDuration)
            ..addListener(() {
              if (!mounted || _resourcesDisposed) return;
              try {
                setState(() {
                  _remainingSeconds =
                      _gameSettings.gameDuration.inSeconds -
                      (_timerAnimationController.value *
                              _gameSettings.gameDuration.inSeconds)
                          .round();
                });
                if (_remainingSeconds <= 0 && !_gameEnded) {
                  _gameEnded = true;
                  _timerAnimationController.stop();
                  // Instead of post-frame, do navigation directly if safe
                  _endGameAndNavigate();
                }
              } catch (e, stack) {
                print('Error in timer animation: $e\n$stack');
              }
            });
      _timerAnimationController.forward();

      try {
        _accelerometerSubscription = accelerometerEvents.listen((
          AccelerometerEvent event,
        ) {
          if (!mounted ||
              _isTiltDebounced ||
              _remainingSeconds <= 0 ||
              _gameEnded ||
              _resourcesDisposed)
            return;

          try {
            const double tiltThreshold = 7.0; // Adjust for sensitivity

            if (event.y > tiltThreshold) {
              _gameSettings.incrementCorrect();
              HapticFeedback.lightImpact();
              _debounceTilt();
              _moveToNextWord();
            } else if (event.y < -tiltThreshold) {
              _gameSettings.incrementPass();
              HapticFeedback.mediumImpact();
              _debounceTilt();
              _moveToNextWord();
            }
          } catch (e, stack) {
            print('Error in accelerometer listener: $e\n$stack');
          }
        });
      } catch (e, stack) {
        print(
          'Error setting up accelerometer: $e - This is normal on iOS simulator\n$stack',
        );
        // Continue without accelerometer - app will still work
      }
    } catch (e, stack) {
      print('Error initializing gameplay screen: $e\n$stack');
    }
  }

  void _endGameAndNavigate() {
    if (!mounted) return;
    try {
      print('[DEBUG] Disposing gameplay resources before navigation');
      _disposeGameplayResources();
      if (mounted) {
        print('[DEBUG] Navigating to /gameOver');
        Navigator.of(context).pushReplacementNamed('/gameOver');
        print('[DEBUG] Navigation to /gameOver complete');
      }
    } catch (e, stack) {
      print('Error navigating to game over: $e\n$stack');
    }
  }

  void _debounceTilt() {
    _isTiltDebounced = true;
    Future.delayed(_debounceDuration, () {
      if (mounted && !_resourcesDisposed) {
        _isTiltDebounced = false;
      }
    });
  }

  void _moveToNextWord() {
    if (!mounted || _resourcesDisposed) return;
    try {
      setState(() {
        _currentWordIndex = (_currentWordIndex + 1) % _currentWords.length;
        if (_currentWordIndex == 0 && _currentWords.length > 1) {
          _currentWords.shuffle();
        }
      });
    } catch (e, stack) {
      print('Error moving to next word: $e\n$stack');
    }
  }

  void _disposeGameplayResources() {
    if (_resourcesDisposed) return;
    _resourcesDisposed = true;

    try {
      print('[DEBUG] Disposing timer animation controller');
      if (_timerAnimationController.isAnimating) {
        _timerAnimationController.stop();
      }
      _timerAnimationController.dispose();
      print('[DEBUG] Timer animation controller disposed');
    } catch (e, stack) {
      print('Error disposing animation controller: $e\n$stack');
    }

    try {
      print('[DEBUG] Canceling accelerometer subscription');
      _accelerometerSubscription?.cancel();
      print('[DEBUG] Accelerometer subscription canceled');
    } catch (e, stack) {
      print('Error canceling accelerometer subscription: $e\n$stack');
    }
  }

  @override
  void dispose() {
    // Unlock orientation for all screens when leaving gameplay
    OrientationManager.unlockOrientation();
    Provider.of<GameSettings>(
      context,
      listen: false,
    ).setGameLandscapeMode(false);
    _disposeGameplayResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        gameSettings.isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;
    final deviceIsLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (!_waitedForOrientation || !deviceIsLandscape) {
      // Block gameplay UI until device is physically in landscape
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.screen_rotation, color: Colors.white, size: 80),
                SizedBox(height: 20),
                Text(
                  'Please rotate your device to landscape to play!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    // Responsive layout for gameplay UI
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.9), // Blue
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.9), // Red
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutBack,
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      child: Text(
                        _currentWords[_currentWordIndex],
                        key: ValueKey<int>(
                          _currentWordIndex,
                        ), // Unique key for animation
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: 90,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black38,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Live Timer
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: _remainingSeconds <= 10
                              ? Colors.redAccent.shade400
                              : Colors.white,
                          shadows: [
                            if (_remainingSeconds <= 10)
                              const Shadow(
                                blurRadius: 8.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Score Counter
                  Consumer<GameSettings>(
                    builder: (context, gameSettings, child) {
                      return Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ... existing code ...
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Subtle Gyroscope Instructions (optional, could fade out after initial seconds)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 40,
                            color: Colors.white54,
                          ),
                          Text(
                            'Pass',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white54),
                          ),
                          const SizedBox(height: 10),
                          Icon(
                            Icons.arrow_downward,
                            size: 40,
                            color: Colors.white54,
                          ),
                          Text(
                            'Correct',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- 7. Game Over / Score Screen ---
class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with UnlockedOrientationMixin {
  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9), // Blue
              Theme.of(context).colorScheme.secondary.withOpacity(0.9), // Red
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TIME\'S UP!',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.redAccent.shade100,
                    fontSize: isLandscape ? 80 : 100,
                  ),
                ),
                SizedBox(height: isLandscape ? 30 : 50),
                // Use Wrap for responsive score layout
                Wrap(
                  spacing: isLandscape ? 40 : 60,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _ScoreDisplay(
                      label: 'CORRECT',
                      score: gameSettings.correctAnswers,
                      color: Theme.of(context).colorScheme.secondary,
                      isLandscape: isLandscape,
                    ), // Red
                    _ScoreDisplay(
                      label: 'PASSES',
                      score: gameSettings.passes,
                      color: Theme.of(context).colorScheme.tertiary,
                      isLandscape: isLandscape,
                    ), // Blue
                  ],
                ),
                SizedBox(height: isLandscape ? 40 : 70),
                // Use Wrap for responsive button layout
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    TempoButton(
                      text: 'CHANGE CATEGORY/TIME',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/gameSetup');
                      },
                      isPrimary: false,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      icon: Icons.tune,
                    ),
                    TempoButton(
                      text: 'PLAY AGAIN',
                      onPressed: () {
                        gameSettings.resetScore();
                        Navigator.pushReplacementNamed(context, '/countdown');
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      icon: Icons.refresh,
                    ),
                    TempoButton(
                      text: 'MAIN MENU',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      isPrimary: false,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary, // Blue
                      icon: Icons.home,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool isLandscape;

  const _ScoreDisplay({
    required this.label,
    required this.score,
    required this.color,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white70,
            fontSize: isLandscape ? 24 : 32,
          ),
        ),
        SizedBox(height: isLandscape ? 8 : 10),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color,
            fontSize: isLandscape ? 80 : 100,
          ),
        ),
      ],
    );
  }
}

// --- How to Play Screen ---
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play Tempo'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.9), // Red
              Theme.of(context).colorScheme.primary.withOpacity(0.9), // Blue
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 10,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isLandscape ? 800 : double.infinity,
                ),
                padding: EdgeInsets.all(isLandscape ? 20.0 : 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TEMPO GAME RULES',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: isLandscape ? 28 : 35,
                            color: Theme.of(context).primaryColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isLandscape ? 20 : 40),
                    Divider(
                      height: isLandscape ? 20 : 40,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    _InstructionStep(
                      step: '1. CHOOSE A CATEGORY:',
                      description:
                          'Select from a diverse range of built-in categories or unleash your creativity by crafting your own custom word lists. The more words, the merrier!',
                      icon: Icons.category,
                      iconColor: Theme.of(context).colorScheme.tertiary, // Blue
                      isLandscape: isLandscape,
                    ),
                    _InstructionStep(
                      step: '2. SET YOUR TIME:',
                      description:
                          'Decide on the perfect duration for your charades round. A typical round lasts between 60 to 90 seconds, but you can customize it!',
                      icon: Icons.timer,
                      iconColor: Theme.of(context).colorScheme.secondary, // Red
                      isLandscape: isLandscape,
                    ),
                    _InstructionStep(
                      step: '3. START PLAYING:',
                      description:
                          'Hold your device to your forehead, displaying the word to your teammates. They\'ll provide clues to help you guess the word without using any of the words on screen!',
                      icon: Icons.play_arrow,
                      iconColor: Theme.of(context).primaryColor, // Blue
                      isLandscape: isLandscape,
                    ),
                    _InstructionStep(
                      step: '4. GYROSCOPE CONTROLS:',
                      description:
                          'No buttons needed! Tempo uses intuitive tilt controls:',
                      icon: Icons.screen_rotation,
                      iconColor: Theme.of(context).colorScheme.tertiary, // Blue
                      isLandscape: isLandscape,
                      subSteps: const [
                        _InstructionSubStep(
                          instruction:
                              'Tilt your device **DOWN** when your team correctly guesses the word!',
                          icon: Icons.arrow_circle_down,
                          iconColor: Colors.green,
                        ),
                        _InstructionSubStep(
                          instruction:
                              'Tilt your device **UP** to pass on a word you can\'t guess or don\'t know.',
                          icon: Icons.arrow_circle_up,
                          iconColor: Colors.orange,
                        ),
                      ],
                    ),
                    _InstructionStep(
                      step: '5. REVIEW SCORES:',
                      description:
                          'Once the timer runs out, the game ends! You\'ll see a summary of your team\'s correct guesses and passes. Challenge yourself to beat your high score!',
                      icon: Icons.emoji_events,
                      iconColor: Theme.of(context).colorScheme.secondary, // Red
                      isLandscape: isLandscape,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final String step;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<_InstructionSubStep>? subSteps;
  final bool isLandscape;

  const _InstructionStep({
    required this.step,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.subSteps,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isLandscape ? 8.0 : 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: isLandscape ? 24 : 30, color: iconColor),
              SizedBox(width: isLandscape ? 12 : 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: isLandscape ? 18 : 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 3 : 5),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isLandscape ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subSteps != null)
            Padding(
              padding: EdgeInsets.only(
                left: isLandscape ? 36.0 : 45.0,
                top: isLandscape ? 8.0 : 10.0,
              ),
              child: Column(children: subSteps!),
            ),
        ],
      ),
    );
  }
}

class _InstructionSubStep extends StatelessWidget {
  final String instruction;
  final IconData icon;
  final Color iconColor;

  const _InstructionSubStep({
    required this.instruction,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isLandscape ? 3.0 : 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: isLandscape ? 20 : 24, color: iconColor),
          SizedBox(width: isLandscape ? 8 : 10),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: isLandscape ? 13 : 15),
            ),
          ),
        ],
      ),
    );
  }
}
