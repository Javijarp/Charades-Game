import 'package:flutter/material.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';
import 'package:what/src/widgets/score_display.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';

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
                    fontSize: isLandscape ? 80 : 80,
                  ),
                ),
                SizedBox(height: isLandscape ? 30 : 50),
                // Use Wrap for responsive score layout
                Wrap(
                  spacing: isLandscape ? 40 : 50,
                  runSpacing: 0,
                  alignment: WrapAlignment.center,
                  children: [
                    ScoreDisplay(
                      label: 'CORRECT',
                      score: gameSettings.correctAnswers,
                      color: Theme.of(context).colorScheme.secondary,
                      isLandscape: isLandscape,
                    ), // Red
                    ScoreDisplay(
                      label: 'PASSES',
                      score: gameSettings.passes,
                      color: Theme.of(context).colorScheme.tertiary,
                      isLandscape: isLandscape,
                    ), // Blue
                  ],
                ),
                SizedBox(height: isLandscape ? 40 : 50),
                // Use Wrap for responsive button layout
                Wrap(
                  runSpacing: 10,
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
