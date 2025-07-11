import 'package:flutter/material.dart';
import 'package:what/src/models/category.dart' show Category;
import 'package:what/src/services/game_settings.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:provider/provider.dart';

// --- 3. Create Custom Category Screen ---
class CreateCustomCategoryScreen extends StatefulWidget {
  const CreateCustomCategoryScreen({super.key});

  @override
  _CreateCustomCategoryScreenState createState() =>
      _CreateCustomCategoryScreenState();
}

class _CreateCustomCategoryScreenState extends State<CreateCustomCategoryScreen>
    with UnlockedOrientationMixin {
  final _categoryNameController = TextEditingController();
  final _wordListController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _categoryNameController.dispose();
    _wordListController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final categoryName = _categoryNameController.text.trim();
      final wordsString = _wordListController.text.trim();
      final words = wordsString
          .split(RegExp(r'[,;\n]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      if (words.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter at least one word for your category.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final newCategory = Category(
        name: categoryName,
        words: words,
        isCustom: true,
      );
      Provider.of<GameSettings>(
        context,
        listen: false,
      ).addCustomCategory(newCategory);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Category "${newCategory.name}" saved!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      Navigator.pop(context); // Go back to category selection
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        Provider.of<GameSettings>(context).isGameLandscapeMode ||
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Category'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 10,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isLandscape ? 600 : double.infinity,
              ),
              padding: EdgeInsets.all(isLandscape ? 20.0 : 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Define Your Category',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: isLandscape ? 24 : 30,
                            color: Theme.of(context).primaryColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isLandscape ? 20 : 30),
                    TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'e.g., 90s Throwback',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _wordListController,
                      maxLines: isLandscape ? 4 : 6,
                      decoration: InputDecoration(
                        labelText: 'Word List',
                        hintText:
                            'Enter words separated by commas or on new lines (e.g., \'Titanic, Spice Girls, Tamagotchi\')',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter at least one word.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isLandscape ? 30 : 40),
                    // Use Wrap for responsive button layout
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        TempoButton(
                          text: 'SAVE CATEGORY',
                          onPressed: _saveCategory,
                          icon: Icons.save,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary, // Red
                        ),
                        TempoButton(
                          text: 'CANCEL',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          isPrimary: false,
                          icon: Icons.cancel_outlined,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary, // Blue
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
