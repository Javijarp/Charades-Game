import 'dart:async';
import 'package:flutter/material.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/orientation_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

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
  bool _isTiltDebounced = false;
  static const Duration _debounceDuration = Duration(milliseconds: 500);
  bool _gameEnded = false;
  bool _resourcesDisposed = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Feedback
  String? _feedbackType;
  bool _showingFeedback = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Background color animation
  Color _backgroundColor = Colors.transparent;
  bool _isBackgroundAnimating = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await OrientationManager.lockToLandscape();
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) setState(() => _waitedForOrientation = true);
      Provider.of<GameSettings>(
        context,
        listen: false,
      ).setGameLandscapeMode(true);
    });

    try {
      _gameSettings = Provider.of<GameSettings>(context, listen: false);
      _currentWords = List.from(_gameSettings.selectedCategory!.words)
        ..shuffle();
      _currentWordIndex = 0;
      _remainingSeconds = _gameSettings.gameDuration.inSeconds;

      _timerAnimationController =
          AnimationController(vsync: this, duration: _gameSettings.gameDuration)
            ..addListener(() {
              if (!mounted || _resourcesDisposed) return;
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
                _endGameAndNavigate();
              }
            });

      _timerAnimationController.forward();

      _accelerometerSubscription = accelerometerEvents.listen((event) async {
        if (!mounted ||
            _isTiltDebounced ||
            _remainingSeconds <= 0 ||
            _gameEnded ||
            _resourcesDisposed) {
          return;
        }

        const double tiltThreshold = 8.0;
        const double strongTiltThreshold = 12.0;

        if (event.z < -tiltThreshold) {
          final isForceful = event.z < -strongTiltThreshold;
          _gameSettings.incrementPass();
          await playFeedback("pass", isForceful: isForceful);
          _debounceTilt();
          _moveToNextWordWithFeedback("pass");
        } else if (event.z > tiltThreshold) {
          final isForceful = event.z > strongTiltThreshold;
          _gameSettings.incrementCorrect();
          await playFeedback("correct", isForceful: isForceful);
          _debounceTilt();
          _moveToNextWordWithFeedback("correct");
        }
      });
    } catch (e, stack) {
      print('Error initializing gameplay screen: $e\n$stack');
    }
  }

  Future<void> playFeedback(String type, {required bool isForceful}) async {
    try {
      final audioPath = 'assets/sounds/${type.toLowerCase()}.mp3';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath.split('assets/').last));

      if (isForceful) {
        HapticFeedback.heavyImpact();
      } else {
        type == 'correct'
            ? HapticFeedback.mediumImpact()
            : HapticFeedback.lightImpact();
      }
    } catch (e) {
      print('Failed to play $type feedback: $e');
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

  void _moveToNextWordWithFeedback(String feedbackType) {
    if (!mounted || _resourcesDisposed) return;

    setState(() {
      _feedbackType = feedbackType;
      _showingFeedback = true;
      _isBackgroundAnimating = true;

      // Set background color based on feedback type
      if (feedbackType == "correct") {
        _backgroundColor = Colors.green.withOpacity(0.3);
      } else if (feedbackType == "pass") {
        _backgroundColor = Colors.orange.withOpacity(0.3);
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _resourcesDisposed) return;
      setState(() {
        _feedbackType = null;
        _showingFeedback = false;
        _isBackgroundAnimating = false;
        _backgroundColor = Colors.transparent;
        _currentWordIndex = (_currentWordIndex + 1) % _currentWords.length;
        if (_currentWordIndex == 0 && _currentWords.length > 1) {
          _currentWords.shuffle();
        }
      });
    });
  }

  void _endGameAndNavigate() {
    if (!mounted) return;
    _disposeGameplayResources();
    _gameSettings.setGameLandscapeMode(false);
    Navigator.of(context).pushReplacementNamed('/gameOver');
  }

  void _disposeGameplayResources() {
    if (_resourcesDisposed) return;
    _resourcesDisposed = true;

    if (_timerAnimationController.isAnimating) {
      _timerAnimationController.stop();
    }
    _timerAnimationController.dispose();
    _accelerometerSubscription?.cancel();
    _audioPlayer.dispose();
  }

  @override
  void dispose() {
    _disposeGameplayResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        gameSettings.isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (!_waitedForOrientation || !isLandscape) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
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
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isBackgroundAnimating
                      ? _backgroundColor
                      : Colors.transparent,
                ),
                child: Stack(
                  children: [
                    // Instructions
                    _buildInstructions(),

                    // Feedback Overlay
                    if (_showingFeedback && _feedbackType != null)
                      Align(
                        alignment: const Alignment(0, 4),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 185.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _feedbackType == "correct"
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.orange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _feedbackType == "correct" ? "CORRECT!" : "PASS!",
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black45,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Word
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
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
                            key: ValueKey<int>(_currentWordIndex),
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

                    // Timer
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
                            shadows: _remainingSeconds <= 10
                                ? const [
                                    Shadow(
                                      blurRadius: 8.0,
                                      color: Colors.white,
                                      offset: Offset(0, 0),
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container();
  }
}
