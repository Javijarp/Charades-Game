import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool isLandscape;
  final double fontSize;

  const ScoreDisplay({
    super.key,
    required this.label,
    required this.score,
    required this.color,
    this.fontSize = 32,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: isLandscape ? 24 : 32,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 16 : 20,
            vertical: isLandscape ? 16 : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // High-contrast background
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isLandscape ? 8 : 10),
              Text(
                score.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: color,
                  fontSize: fontSize,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
