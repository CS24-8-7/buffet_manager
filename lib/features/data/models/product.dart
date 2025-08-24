import 'package:hive/hive.dart';
part 'product.g.dart';
@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String? image;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String category;

  @HiveField(6)
  bool isAvailable;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.image,
    this.description,
    this.category = 'عام',
    this.isAvailable = true,
  });

  String get formattedPrice => '${price.toStringAsFixed(2)} ريال';
}
