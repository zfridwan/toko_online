import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String image;
  final DateTime creationAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['name'] ?? '', // Default to empty string if null
      image: json['image'] ?? '', // Default to empty string if null
      creationAt: json['creationAt'] != null
          ? DateTime.tryParse(json['creationAt']) ?? DateTime.now()
          : DateTime.now(), // Default to current date if null
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(), // Default to current date if null
    );
  }

  @override
  List<Object?> get props => [id, name, image, creationAt, updatedAt];
}
