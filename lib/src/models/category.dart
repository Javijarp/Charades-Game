// --- Data Models ---
class Category {
  final String name;
  final List<String> words;
  final bool isCustom;

  Category({required this.name, required this.words, this.isCustom = false});
}
