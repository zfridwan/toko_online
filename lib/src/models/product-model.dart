import 'category-model.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final Category category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: _parsePrice(json['price']),
      image: _getFirstImage(json['images']),
      category: Category.fromJson(json['category'] ?? {}),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      return price.toDouble();
    } else {
      return 0.0;
    }
  }

  static String _getFirstImage(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images[0] as String;
    }
    return '';
  }
}
