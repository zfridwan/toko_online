import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/category-model.dart';
import '../models/product-model.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.0.10:3000';

  final http.Client httpClient;

  ApiService({http.Client? client}) : httpClient = client ?? http.Client();

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'api_key': Constants.apiKey,
    };
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/categories'),
        headers: _getHeaders(),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonList = json.decode(response.body);
          return jsonList.map((json) => Category.fromJson(json)).toList();
        } catch (e) {
          throw FormatException('Invalid JSON format: $e');
        }
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
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/products'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) {
              try {
                return Product.fromJson(json);
              } catch (e) {
                print('Error parsing product: $e');
                return null;
              }
            })
            .where((product) => product != null)
            .cast<Product>()
            .toList();
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
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/products?categoryId=$categoryId'),
        headers: _getHeaders(),
      );

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
