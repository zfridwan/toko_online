import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category-model.dart';
import '../models/product-model.dart';

class ApiService {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1';
  final http.Client httpClient;

  ApiService({http.Client? client}) : httpClient = client ?? http.Client();

  Future<List<Category>> getCategories() async {
    try {
      final response = await httpClient.get(Uri.parse('$_baseUrl/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await httpClient.get(Uri.parse('$_baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$_baseUrl/products?categoryId=$categoryId'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products for category $categoryId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products for category $categoryId: $e');
      rethrow;
    }
  }
}
