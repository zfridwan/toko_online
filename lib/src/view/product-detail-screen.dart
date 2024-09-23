import 'package:flutter/material.dart';
import '../core/cart-mock.dart';
import '../core/mock-database.dart';
import '../models/product-model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  void _addToCart(BuildContext context) {
    Cart().menambahkanKeranjang(product);
    print('Product ditambahkan: ${product.title}');
    print('Keranjang Masuk: ${Cart().items}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} berhasil ditambahkan ke keranjang!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    product.image,
                    height: isPortrait
                        ? screenSize.height * 0.25
                        : screenSize.height * 0.3,
                    width: isPortrait
                        ? screenSize.width * 0.5
                        : screenSize.width * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: \$${product.price}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.description ?? 'Deskripsi tidak tersedia.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _addToCart(context),
                  child: Text('Tambahkan Keranjang'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                      horizontal: screenSize.width * 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
