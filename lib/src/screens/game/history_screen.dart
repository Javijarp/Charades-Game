import 'package:flutter/material.dart';
import 'package:what/src/models/game_history.dart';
import 'package:what/src/services/game_history_service.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<GameHistory> _allHistory = [];
  String? _selectedCategory;
  List<GameHistory> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _allHistory = GameHistoryService.getAllHistory();
      _filteredHistory = _allHistory;
      print(
        'HistoryScreen: Loaded ${_allHistory.length} games, filtered: ${_filteredHistory.length}',
      );
    });
  }

  void _filterByCategory(String? categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      if (categoryName == null) {
        _filteredHistory = _allHistory;
      } else {
        _filteredHistory = GameHistoryService.getHistoryForCategory(
          categoryName,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final allCategories = gameSettings.allCategories;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadHistory(),
            tooltip: 'Refresh History',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _showClearHistoryDialog(),
            tooltip: 'Clear All History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...allCategories.map(
                      (category) => DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: _filterByCategory,
                ),
                const SizedBox(height: 12),
                TempoButton(
                  text: 'CATEGORIES',
                  onPressed: () => Navigator.pushNamed(context, '/categories'),
                  icon: Icons.category,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),

          // Statistics Summary
          if (_selectedCategory != null) _buildCategoryStats(),

          // History List
          Expanded(
            child: _filteredHistory.isEmpty
                ? _buildEmptyState()
                : _buildHistoryList(isLandscape),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStats() {
    if (_selectedCategory == null) return const SizedBox.shrink();

    final stats = GameHistoryService.getCategoryStats(_selectedCategory!);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics for $_selectedCategory',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Games', stats['totalGames'].toString()),
              _buildStatItem('Best Score', stats['bestScore'].toString()),
              _buildStatItem('Avg Score', stats['averageScore'].toString()),
              _buildStatItem('Correct', stats['totalCorrect'].toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedCategory == null
                ? 'No games played yet!'
                : 'No games played in $_selectedCategory yet!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start playing to see your history here.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          // Debug info
          Text(
            'Debug: Total games in database: ${_allHistory.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          TempoButton(
            text: 'PLAY GAME',
            onPressed: () => Navigator.pushNamed(context, '/gameSetup'),
            icon: Icons.play_arrow,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isLandscape) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredHistory.length,
      itemBuilder: (context, index) {
        final game = _filteredHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 4,
          child: InkWell(
            onTap: () => _showGameDetails(game),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: game.isCustomCategory
                            ? Colors.orange
                            : Theme.of(context).colorScheme.primary,
                        child: Icon(
                          game.isCustomCategory ? Icons.edit : Icons.category,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.categoryName,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy - HH:mm',
                              ).format(game.playedAt),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Score: ${game.totalScore}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${game.gameDuration.inMinutes}:${(game.gameDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatChip(
                        Icons.check_circle,
                        '${game.correctAnswers}',
                        'Correct',
                        Colors.green,
                      ),
                      _buildStatChip(
                        Icons.skip_next,
                        '${game.passes}',
                        'Passes',
                        Colors.orange,
                      ),
                      _buildStatChip(
                        Icons.timer,
                        '${game.gameDuration.inMinutes}:${(game.gameDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                        'Duration',
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: color.withOpacity(0.8), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGameDetails(GameHistory game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Details - ${game.categoryName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('EEEE, MMMM dd, yyyy').format(game.playedAt)}',
            ),
            Text('Time: ${DateFormat('HH:mm:ss').format(game.playedAt)}'),
            const SizedBox(height: 16),
            Text('Correct Answers: ${game.correctAnswers}'),
            Text('Passes: ${game.passes}'),
            Text(
              'Duration: ${game.gameDuration.inMinutes}:${(game.gameDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 16),
            Text(
              'Total Score: ${game.totalScore}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addTestData() async {
    try {
      final testGame = GameHistory(
        playedAt: DateTime.now(),
        categoryName: 'Test Category',
        correctAnswers: 5,
        passes: 2,
        gameDuration: const Duration(minutes: 2, seconds: 30),
        totalScore: 85,
        isCustomCategory: false,
      );

      await GameHistoryService.saveGameResult(testGame);
      print('HistoryScreen: Added test data successfully');
      _loadHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test data added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('HistoryScreen: Error adding test data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding test data: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: Text(
          _selectedCategory == null
              ? 'Are you sure you want to clear all game history?'
              : 'Are you sure you want to clear history for $_selectedCategory?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (_selectedCategory == null) {
                await GameHistoryService.clearAllHistory();
              } else {
                await GameHistoryService.deleteHistoryForCategory(
                  _selectedCategory!,
                );
              }
              _loadHistory();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
