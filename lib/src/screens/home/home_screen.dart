import 'package:flutter/material.dart';
import 'package:what/src/models/category.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';

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
