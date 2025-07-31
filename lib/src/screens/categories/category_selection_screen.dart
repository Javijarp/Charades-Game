import 'package:flutter/material.dart';
import 'package:what/src/models/category.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
          final allCategories = [
            ...gameSettings.customCategories,
            ...gameSettings.categories,
          ];

          if (isLandscape) {
            // Landscape layout: side-by-side
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      return Card(
                        color: Colors.white,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ), // Blue
                          ),
                          subtitle: Text(
                            '${category.words.length} words',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (gameSettings.selectedCategory?.name ==
                                  category.name)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  size: 28,
                                ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey.shade700,
                                ),
                                tooltip: 'Edit category',
                                onPressed: () {
                                  final index = gameSettings.customCategories
                                      .indexOf(category);
                                  Navigator.pushNamed(
                                    context,
                                    '/createCategory',
                                    arguments: {
                                      'category':
                                          category, // <-- Pasamos la categoría a editar
                                      'index': index,
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  final index = gameSettings.customCategories
                                      .indexOf(category);
                                  gameSettings.deleteCustomCategory(index);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            gameSettings.selectCategory(category);
                            Navigator.pushNamed(context, '/gameSetup');
                          },
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
                              ?.copyWith(color: Colors.blueGrey.shade500),
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
                    padding: const EdgeInsets.all(20.0),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      return Card(
                        color: Colors.white,
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ), // Blue
                          ),
                          trailing:
                              gameSettings.selectedCategory?.name ==
                                  category.name
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  size: 30,
                                ) // Red
                              : null,
                          onTap: () {
                            gameSettings.selectCategory(category);
                            Navigator.pushNamed(context, '/gameSetup');
                          },
                        ),
                      );
                    },
                  ),
                ),
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
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
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
}
