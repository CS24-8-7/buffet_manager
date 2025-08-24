import 'product.dart';
import 'package:hive/hive.dart';
part 'cart_item.g.dart';

@HiveType(typeId: 1) // typeId خاص بكل موديل ويجب أن يكون فريد
class CartItem extends HiveObject {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
  String get formattedTotalPrice => '${totalPrice.toStringAsFixed(2)} ريال';

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

