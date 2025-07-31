import 'package:hive/hive.dart';
import 'package:what/src/models/category.dart';

class CustomCategoryService {
  static final _box = Hive.box<Category>('categories');

  List<Category> getAllCategories() => _box.values.toList();

  Future<void> addCategory(Category category) async {
    await _box.add(category);
  }

  Future<void> updateCategory(int key, Category category) async {
    await _box.put(key, category);
  }

  Future<void> deleteCategory(int key) async {
    await _box.delete(key);
  }

  Future<void> addPredefinedCategories() async {
    final categoryBox = Hive.box<Category>('categories');

    if (categoryBox.isEmpty) {
      final predefinedCategories = [
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

      for (var category in predefinedCategories) {
        await categoryBox.add(category);
      }
    }
  }
}
