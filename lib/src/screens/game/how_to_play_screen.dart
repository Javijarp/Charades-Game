import 'package:flutter/material.dart';

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
