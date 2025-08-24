import 'package:hive/hive.dart';

part 'sale.g.dart';

@HiveType(typeId: 3)
class Sale extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  double total;
  @HiveField(3)
  String? cashierName;

  @HiveField(4)
  String? notes;

  Sale({
    this.id,
    required this.date,
    required this.total,
    this.cashierName,
    this.notes,
  });

  String get formattedTotal => '${total.toStringAsFixed(2)} ريال';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

@HiveType(typeId: 4)
class SaleItem extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int saleId;

  @HiveField(2)
  int productId;

  @HiveField(3)
  String productName;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  double price;

  @HiveField(6)
  double total;

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  String get formattedPrice => '${price.toStringAsFixed(2)} ريال';
  String get formattedTotal => '${total.toStringAsFixed(2)} ريال';
}

