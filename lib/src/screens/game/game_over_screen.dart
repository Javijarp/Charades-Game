import 'package:flutter/material.dart';
import 'package:what/src/models/game_history.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/game_history_service.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';
import 'package:what/src/widgets/score_display.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with UnlockedOrientationMixin {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveGameHistory();
    });
  }

  void _saveGameHistory() async {
    try {
      final gameSettings = Provider.of<GameSettings>(context, listen: false);
      print('GameOverScreen: Attempting to save game history...');
      print('GameOverScreen: Category: ${gameSettings.selectedCategory?.name}');
      print(
        'GameOverScreen: Correct: ${gameSettings.correctAnswers}, Passes: ${gameSettings.passes}',
      );
      print('GameOverScreen: Game Duration: ${gameSettings.gameDuration}');

      if (gameSettings.selectedCategory != null) {
        final gameHistory = GameHistory(
          playedAt: DateTime.now(),
          categoryName: gameSettings.selectedCategory!.name,
          correctAnswers: gameSettings.correctAnswers,
          passes: gameSettings.passes,
          gameDuration: gameSettings.gameDuration,
          totalScore: GameHistory.calculateScore(
            gameSettings.correctAnswers,
            gameSettings.passes,
            gameSettings.gameDuration,
          ),
          isCustomCategory: gameSettings.selectedCategory!.isCustom,
        );

        print(
          'GameOverScreen: Created GameHistory object: ${gameHistory.categoryName}',
        );
        print(
          'GameOverScreen: GameHistory duration: ${gameHistory.gameDuration}',
        );

        await GameHistoryService.saveGameResult(gameHistory);
        print(
          'GameOverScreen: Game history saved successfully: ${gameHistory.categoryName} - Score: ${gameHistory.totalScore}',
        );

        // Test: Try to retrieve the history immediately after saving
        final allHistory = GameHistoryService.getAllHistory();
        print(
          'GameOverScreen: Total games in history after save: ${allHistory.length}',
        );
      } else {
        print('GameOverScreen: No category selected, cannot save game history');
      }
    } catch (e, stackTrace) {
      print('GameOverScreen: Error saving game history: $e');
      print('GameOverScreen: Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    print(
      "GameOverScreen: \n Correct Answers: ${gameSettings.correctAnswers}\n Passes: ${gameSettings.passes}",
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.9),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TIME\'S UP!',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: isLandscape ? 80 : 50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isLandscape ? 5 : 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ScoreDisplay(
                            label: 'CORRECT',
                            score: gameSettings.correctAnswers,
                            color: (gameSettings.correctAnswers > 0)
                                ? const Color.fromARGB(255, 46, 227, 140)
                                : Theme.of(context).colorScheme.secondary,
                            isLandscape: isLandscape,
                            fontSize: (gameSettings.correctAnswers > 10)
                                ? 100
                                : 90,
                          ),
                        ),
                        SizedBox(width: isLandscape ? 8 : 24), // Reducido
                        Expanded(
                          child: ScoreDisplay(
                            label: 'PASSES',
                            score: gameSettings.passes,
                            color: (gameSettings.passes > 0)
                                ? Colors.blueAccent
                                : Theme.of(context).colorScheme.secondary,
                            isLandscape: isLandscape,
                            fontSize: (gameSettings.passes > 10) ? 100 : 90,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isLandscape ? 10 : 50),

                    // Botones alineados horizontalmente o verticalmente según orientación
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isLandscape ? 8 : 8,
                      runSpacing: 10,
                      children: [
                        TempoButton(
                          text: 'CATEGORY/TIME',
                          onPressed: () {
                            Navigator.pop(context, '/gameSetup');
                          },
                          isPrimary: false,
                          backgroundColor: Colors.white,
                          icon: Icons.tune,
                        ),
                        TempoButton(
                          text: 'PLAY AGAIN',
                          onPressed: () {
                            gameSettings.resetScore();
                            Navigator.pushReplacementNamed(
                              context,
                              '/countdown',
                            );
                          },
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
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
                          backgroundColor: Colors.white,
                          icon: Icons.home,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
