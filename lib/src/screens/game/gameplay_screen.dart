import 'dart:async';

import 'package:flutter/material.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/orientation_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
      _gameSettings.setGameLandscapeMode(false);
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
    // _gameSettings.setGameLandscapeMode(false);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
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
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
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
