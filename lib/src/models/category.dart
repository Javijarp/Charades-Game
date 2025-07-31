import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> words;
  @HiveField(2)
  bool isCustom;

  Category({required this.name, required this.words, this.isCustom = false});
}
