// --- Game State Management ---
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:what/src/models/category.dart';
import 'package:what/src/services/category_service.dart';

class GameSettings with ChangeNotifier {
  Category? _selectedCategory;
  final bool _firstTimePlaying = true;
  Duration _gameDuration = const Duration(
    minutes: 1,
    seconds: 30,
  ); // Default to 1:30
  int _correctAnswers = 0;
  int _passes = 0;
  bool _isGameLandscapeMode =
      false; // Track if game is in landscape-locked mode

  Category? get selectedCategory => _selectedCategory;
  Duration get gameDuration => _gameDuration;
  int get correctAnswers => _correctAnswers;
  int get passes => _passes;
  bool get isGameLandscapeMode => _isGameLandscapeMode;

  Box<Category>? _categoryBox;

  // Get all categories from Hive box
  List<Category> get allCategories => _categoryBox?.values.toList() ?? [];

  // Get only custom categories
  List<Category> get customCategories =>
      _categoryBox?.values.where((c) => c.isCustom).toList() ?? [];

  Future<void> init() async {
    _categoryBox = Hive.box<Category>('categories');
    notifyListeners();
  }

  void addCustomCategory(Category category) {
    _categoryBox?.add(category);
    notifyListeners();
  }

  void updateCategory(int index, Category updated) {
    if (index >= 0 && index < _categoryBox!.length) {
      final key = _categoryBox!.keyAt(index);
      _categoryBox!.put(key, updated);
      notifyListeners();
    }
  }

  void deleteCategory(int index) {
    if (index >= 0 && index < _categoryBox!.length) {
      final key = _categoryBox!.keyAt(index);
      _categoryBox!.delete(key);
      notifyListeners();
    }
  }

  // Helper method to find category index by name
  int? findCategoryIndexByName(String name) {
    final keys = _categoryBox?.keys.toList() ?? [];
    for (int i = 0; i < keys.length; i++) {
      final category = _categoryBox?.get(keys[i]);
      if (category?.name == name) {
        return i;
      }
    }
    return null;
  }

  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setGameDuration(Duration duration) {
    _gameDuration = duration;
    notifyListeners();
  }

  void resetScore() {
    _correctAnswers = 0;
    _passes = 0;
    notifyListeners();
  }

  void incrementCorrect() {
    _correctAnswers++;
    notifyListeners();
  }

  void incrementPass() {
    _passes++;
    notifyListeners();
  }

  void setGameLandscapeMode(bool value) {
    if (_isGameLandscapeMode != value) {
      _isGameLandscapeMode = value;
      notifyListeners();
    }
  }
}
