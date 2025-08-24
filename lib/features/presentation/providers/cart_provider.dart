import 'package:flutter/material.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../data/services/database_service.dart';
class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  String get formattedTotalPrice => '${totalPrice.toStringAsFixed(2)} ريال';
  bool get isEmpty => _cartItems.isEmpty;

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  CartItem? getCartItem(Product product) {
    try {
      return _cartItems.firstWhere((item) => item.product.id == product.id);
    } catch (e) {
      return null;
    }
  }

  int getProductQuantity(Product product) {
    final cartItem = getCartItem(product);
    return cartItem?.quantity ?? 0;
  }

  Future<int?> completeSale(String? cashierName, String? notes) async {
    if (_cartItems.isEmpty) return null;

    try {
      final saleId = await DatabaseService.insertSale(
        DateTime.now(),
        totalPrice,
        cashierName,
        notes,
      );

      for (var item in _cartItems) {
        await DatabaseService.insertSaleItem(
          saleId,
          item.product.id!,
          item.product.name,
          item.quantity,
          item.product.price,
        );
      }

      clearCart();
      return saleId;
    } catch (e) {
      print('Error completing sale: $e');
      return null;
    }
  }
}

