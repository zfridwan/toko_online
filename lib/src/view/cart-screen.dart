import 'package:flutter/material.dart';
import '../core/cart-mock.dart';
import '../models/cart-item-model.dart';
import 'checkout-screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _calculateTotalPrice(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Cart();
    final cartItems = cart.items;
    final totalPrice = _calculateTotalPrice(cartItems);

    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Keranjang Kosong',
                style: TextStyle(fontSize: 14),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                    vertical: screenSize.height * 0.01,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      item.product.image,
                      width: isPortrait
                          ? screenSize.width * 0.15
                          : screenSize.width * 0.10,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.product.title,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      'Quantity: ${item.quantity}\nTotal: \$${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () {
                            setState(() {
                              cart.menambahkanKeranjang(item.product);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () {
                            setState(() {
                              cart.mengurangiKeranjang(item.product);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.height * 0.02,
        ),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              },
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.1,
                  vertical: screenSize.height * 0.015,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
