import 'package:flutter/material.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';

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
