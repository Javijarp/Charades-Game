import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool isLandscape;

  const ScoreDisplay({
    super.key,
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
