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
  final List<Category> _customCategories = []; // To store custom categories
  final List<Category> categories = CustomCategoryService()
      .getAllCategories(); // To store custom categories
  bool _isGameLandscapeMode =
      false; // Track if game is in landscape-locked mode

  Category? get selectedCategory => _selectedCategory;
  Duration get gameDuration => _gameDuration;
  int get correctAnswers => _correctAnswers;
  int get passes => _passes;
  bool get isGameLandscapeMode => _isGameLandscapeMode;

  Box<Category>? _categoryBox;
  List<Category> get customCategories => _customCategories;

  Future<void> init() async {
    _categoryBox = Hive.box<Category>('categories');
    _customCategories.clear();
    _customCategories.addAll(_categoryBox!.values.where((c) => c.isCustom));
    notifyListeners();
  }

  void addCustomCategory(Category category) {
    _categoryBox?.add(category);
    _customCategories.add(category);
    notifyListeners();
  }

  void updateCustomCategory(int index, Category updated) {
    final key = _categoryBox!.keyAt(index);
    _categoryBox!.put(key, updated);
    _customCategories[index] = updated;
    notifyListeners();
  }

  void deleteCustomCategory(int index) {
    final key = _categoryBox!.keyAt(index);
    _categoryBox!.delete(key);
    _customCategories.removeAt(index);
    notifyListeners();
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
