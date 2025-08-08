import 'package:hive/hive.dart';

part 'game_history.g.dart';

@HiveType(typeId: 1)
class GameHistory extends HiveObject {
  @HiveField(0)
  DateTime playedAt;

  @HiveField(1)
  String categoryName;

  @HiveField(2)
  int correctAnswers;

  @HiveField(3)
  int passes;

  @HiveField(4)
  Duration gameDuration;

  @HiveField(5)
  int totalScore;

  @HiveField(6)
  bool isCustomCategory;

  GameHistory({
    required this.playedAt,
    required this.categoryName,
    required this.correctAnswers,
    required this.passes,
    required this.gameDuration,
    required this.totalScore,
    required this.isCustomCategory,
  });

  // Calculate score based on correct answers and passes
  static int calculateScore(int correct, int passes, Duration duration) {
    // Base score: 10 points per correct answer, -2 points per pass
    int baseScore = (correct * 10) - (passes * 2);

    // Bonus for fast completion (more time remaining = higher bonus)
    int timeBonus = (duration.inSeconds / 10).round();

    return baseScore + timeBonus;
  }
}
