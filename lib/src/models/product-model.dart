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
      title: json['title'] ?? '', // Default to empty string if null
      description: json['description'] ?? '', // Default to empty string if null
      price: _parsePrice(
          json['price']), // Call helper function to handle the price conversion
      image: _getFirstImage(json['images']), // Safely get the first image
      category: Category.fromJson(
          json['category'] ?? {}), // Default to empty object if null
    );
  }

  // Helper function to safely parse price
  static double _parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price) ??
          0.0; // Try to parse the string, return 0.0 if it fails
    } else if (price is num) {
      return price
          .toDouble(); // Directly return the double if it's already a number
    } else {
      return 0.0; // Default value in case of any unexpected format
    }
  }

  // Helper function to get the first image safely
  static String _getFirstImage(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return images[0]
          as String; // Return the first image if it's a non-empty list
    }
    return ''; // Return empty string if images is null or empty
  }
}
