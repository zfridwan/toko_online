import 'package:flutter/foundation.dart';

import '../model/cart-item-model.dart';
import '../model/product-model.dart';

class Cart with ChangeNotifier {
  Cart._privateConstructor();

  static final Cart _instance = Cart._privateConstructor();

  factory Cart() => _instance;

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void menambahkanKeranjang(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
  }

  // void removeFromCart(int productId) {
  //   _items.removeWhere((item) => item.product.id == productId);
  // }

  void mengurangiKeranjang(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 1) {
      existingItem.quantity--;
    } else {
      _items.remove(existingItem);
    }
    // Notify listeners if using ChangeNotifier or similar
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
  }
}
