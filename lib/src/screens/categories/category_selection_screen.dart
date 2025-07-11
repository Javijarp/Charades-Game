import 'package:flutter/material.dart';
import 'package:what/src/models/category.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- 2. Category Selection Screen ---
class CategorySelectionScreen extends StatelessWidget {
  final List<Category> predefinedCategories = [
    Category(
      name: 'Movies',
      words: const [
        'Titanic',
        'Avatar',
        'Star Wars',
        'Inception',
        'Jaws',
        'Lion King',
        'Forrest Gump',
        'The Matrix',
        'Pulp Fiction',
        'Spirited Away',
      ],
    ),
    Category(
      name: 'Animals',
      words: const [
        'Dog',
        'Cat',
        'Elephant',
        'Lion',
        'Giraffe',
        'Monkey',
        'Dolphin',
        'Tiger',
        'Panda',
        'Kangaroo',
      ],
    ),
    Category(
      name: 'Sports',
      words: const [
        'Basketball',
        'Soccer',
        'Tennis',
        'Swimming',
        'Baseball',
        'Golf',
        'Volleyball',
        'Boxing',
        'Skiing',
        'Cycling',
      ],
    ),
    Category(
      name: 'Food',
      words: const [
        'Pizza',
        'Burger',
        'Sushi',
        'Taco',
        'Ice Cream',
        'Spaghetti',
        'Chocolate',
        'Donut',
        'Salad',
        'Pancake',
      ],
    ),
    Category(
      name: 'Historical Figures',
      words: const [
        'George Washington',
        'Cleopatra',
        'Albert Einstein',
        'Leonardo da Vinci',
        'Marie Curie',
        'Martin Luther King Jr.',
        'Queen Elizabeth I',
        'Nelson Mandela',
        'Isaac Newton',
        'Joan of Arc',
      ],
    ),
    Category(
      name: 'Pop Culture',
      words: const [
        'Harry Potter',
        'Star Wars',
        'Beyoncé',
        'TikTok',
        'Emoji',
        'Marvel',
        'Game of Thrones',
        'Netflix',
        'Pokémon',
        'Fortnite',
      ],
    ),
  ];

  CategorySelectionScreen({super.key});

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
            ...predefinedCategories,
            ...gameSettings.customCategories,
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
