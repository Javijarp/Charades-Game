import 'package:flutter/material.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  'Set Round Time',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Minutes Picker
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: SizedBox(
                        width: 90,
                        height: 180,
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: _selectedLocalDuration.inMinutes,
                          ),
                          itemExtent: 40,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedLocalDuration = Duration(
                                minutes: value,
                                seconds: _selectedLocalDuration.inSeconds % 60,
                              );
                              // Clamp to max 10:00
                              if (_selectedLocalDuration.inMinutes == 10) {
                                _selectedLocalDuration = Duration(
                                  minutes: 10,
                                  seconds: 0,
                                );
                              }
                              // Clamp to min 0:10
                              if (_selectedLocalDuration.inMinutes == 0 &&
                                  _selectedLocalDuration.inSeconds < 10) {
                                _selectedLocalDuration = Duration(seconds: 10);
                              }
                            });
                            Provider.of<GameSettings>(
                              context,
                              listen: false,
                            ).setGameDuration(_selectedLocalDuration);
                          },
                          children: List<Widget>.generate(11, (int index) {
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 32,
                        height: 2,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                    ),
                    // Seconds Picker
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: SizedBox(
                        width: 90,
                        height: 180,
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: _selectedLocalDuration.inSeconds % 60,
                          ),
                          itemExtent: 40,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              _selectedLocalDuration = Duration(
                                minutes: _selectedLocalDuration.inMinutes,
                                seconds: value,
                              );
                              // Clamp to max 10:00
                              if (_selectedLocalDuration.inMinutes == 10) {
                                _selectedLocalDuration = Duration(
                                  minutes: 10,
                                  seconds: 0,
                                );
                              }
                              // Clamp to min 0:10
                              if (_selectedLocalDuration.inMinutes == 0 &&
                                  _selectedLocalDuration.inSeconds < 10) {
                                _selectedLocalDuration = Duration(seconds: 10);
                              }
                            });
                            Provider.of<GameSettings>(
                              context,
                              listen: false,
                            ).setGameDuration(_selectedLocalDuration);
                          },
                          children: List<Widget>.generate(60, (int index) {
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
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
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isLandscape ? 5 : 30),
              Text(
                'Time per Round:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: isLandscape ? 5 : 10),
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
              SizedBox(height: isLandscape ? 5 : 40),
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
