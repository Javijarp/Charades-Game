import 'package:hive/hive.dart';
import 'package:what/src/models/game_history.dart';

class GameHistoryService {
  static final Box<GameHistory> _box = Hive.box<GameHistory>('game_history');

  // Save a new game result
  static Future<void> saveGameResult(GameHistory game) async {
    try {
      await _box.add(game);
      print('GameHistoryService: Saved game result for ${game.categoryName}');
      print('Total games in history: ${_box.length}');
    } catch (e) {
      print('GameHistoryService: Error saving game result: $e');
      rethrow;
    }
  }

  // Get all game history
  static List<GameHistory> getAllHistory() {
    try {
      print('GameHistoryService: Attempting to get all history...');
      print('GameHistoryService: Box length: ${_box.length}');

      final history = _box.values.toList()
        ..sort((a, b) => b.playedAt.compareTo(a.playedAt)); // Most recent first

      print(
        'GameHistoryService: Retrieved ${history.length} games from history',
      );

      // Print details of each game for debugging
      for (int i = 0; i < history.length; i++) {
        final game = history[i];
        print(
          'GameHistoryService: Game $i - ${game.categoryName} - Score: ${game.totalScore} - Date: ${game.playedAt}',
        );
      }

      return history;
    } catch (e) {
      print('GameHistoryService: Error getting history: $e');
      return [];
    }
  }

  // Get history for a specific category
  static List<GameHistory> getHistoryForCategory(String categoryName) {
    return _box.values
        .where((game) => game.categoryName == categoryName)
        .toList()
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));
  }

  // Get recent games (last 10)
  static List<GameHistory> getRecentGames({int limit = 10}) {
    final allGames = getAllHistory();
    return allGames.take(limit).toList();
  }

  // Get best score for a category
  static GameHistory? getBestScoreForCategory(String categoryName) {
    final categoryGames = getHistoryForCategory(categoryName);
    if (categoryGames.isEmpty) return null;

    return categoryGames.reduce((a, b) => a.totalScore > b.totalScore ? a : b);
  }

  // Get overall best score
  static GameHistory? getOverallBestScore() {
    final allGames = getAllHistory();
    if (allGames.isEmpty) return null;

    return allGames.reduce((a, b) => a.totalScore > b.totalScore ? a : b);
  }

  // Get category statistics
  static Map<String, dynamic> getCategoryStats(String categoryName) {
    final categoryGames = getHistoryForCategory(categoryName);

    if (categoryGames.isEmpty) {
      return {
        'totalGames': 0,
        'averageScore': 0,
        'bestScore': 0,
        'totalCorrect': 0,
        'totalPasses': 0,
      };
    }

    final totalGames = categoryGames.length;
    final totalScore = categoryGames.fold(
      0,
      (sum, game) => sum + game.totalScore,
    );
    final averageScore = totalScore / totalGames;
    final bestScore = categoryGames
        .map((g) => g.totalScore)
        .reduce((a, b) => a > b ? a : b);
    final totalCorrect = categoryGames.fold(
      0,
      (sum, game) => sum + game.correctAnswers,
    );
    final totalPasses = categoryGames.fold(0, (sum, game) => sum + game.passes);

    return {
      'totalGames': totalGames,
      'averageScore': averageScore.round(),
      'bestScore': bestScore,
      'totalCorrect': totalCorrect,
      'totalPasses': totalPasses,
    };
  }

  // Delete all history
  static Future<void> clearAllHistory() async {
    await _box.clear();
  }

  // Delete history for a specific category
  static Future<void> deleteHistoryForCategory(String categoryName) async {
    final keysToDelete = <dynamic>[];

    for (int i = 0; i < _box.length; i++) {
      final key = _box.keyAt(i);
      final game = _box.get(key);
      if (game?.categoryName == categoryName) {
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await _box.delete(key);
    }
  }
}
