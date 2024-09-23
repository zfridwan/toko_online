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
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['images'][0],
      category: Category.fromJson(json['category']),
    );
  }
}
