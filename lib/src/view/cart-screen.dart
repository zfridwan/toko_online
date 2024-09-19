import 'package:flutter/material.dart';
import '../core/cart-mock.dart';
import '../model/cart-item-model.dart';
import 'checkout-screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Method to calculate total price of all items in the cart
  double _calculateTotalPrice(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Cart(); // Access the Cart instance
    final cartItems = cart.items;
    final totalPrice = _calculateTotalPrice(cartItems);

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Keranjang Kosong'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.product.image),
                  title: Text(item.product.title),
                  subtitle: Text(
                      'Quantity: ${item.quantity}\nTotal: \$${item.totalPrice}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            cart.menambahkanKeranjang(item.product);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            cart.mengurangiKeranjang(item.product);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Checkout Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              },
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
