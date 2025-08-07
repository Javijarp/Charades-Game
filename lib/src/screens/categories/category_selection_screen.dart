import 'package:flutter/material.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// --- 2. Category Selection Screen ---
class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        Provider.of<GameSettings>(context).isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Category'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<GameSettings>(
        builder: (context, gameSettings, child) {
          final allCategories = gameSettings.allCategories;

          if (isLandscape) {
            // Landscape layout: side-by-side
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];

                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Slidable(
                          key: ValueKey(category.name),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Navigator.pushNamed(
                                    context,
                                    '/createCategory',
                                    arguments: {
                                      'category': category,
                                      'index': index,
                                    },
                                  );
                                },
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  gameSettings.deleteCategory(index);
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: _buildListTile(
                            context,
                            category,
                            gameSettings,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TempoButton(
                          text: 'CREATE NEW',
                          onPressed: () {
                            Navigator.pushNamed(context, '/createCategory');
                          },
                          icon: Icons.add_circle_outline,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary, // Blue
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Choose from predefined categories or create your own!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout: stacked
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];

                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Slidable(
                          key: ValueKey(category.name),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Navigator.pushNamed(
                                    context,
                                    '/createCategory',
                                    arguments: {
                                      'category': category,
                                      'index': index,
                                    },
                                  );
                                },
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  gameSettings.deleteCategory(index);
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: _buildListTile(
                            context,
                            category,
                            gameSettings,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey.shade900, thickness: 5),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TempoButton(
                        text: 'CREATE NEW',
                        onPressed: () {
                          Navigator.pushNamed(context, '/createCategory');
                        },
                        icon: Icons.add_circle_outline,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.tertiary, // Blue
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose from predefined categories or create your own!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    dynamic category,
    GameSettings gameSettings,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        category.name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).primaryColor,
        ), // Blue
      ),
      subtitle: Text(
        '${category.words.length} words',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: gameSettings.selectedCategory?.name == category.name
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            )
          : null,
      onTap: () {
        gameSettings.selectCategory(category);
        Navigator.pushNamed(context, '/gameSetup');
      },
    );
  }
}
