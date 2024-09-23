import 'product-model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  @override
  String toString() {
    return 'CartItem(product: ${product.title}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
