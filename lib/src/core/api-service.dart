import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category-model.dart';
import '../models/product-model.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.0.10/backend';
  final http.Client httpClient;

  ApiService({http.Client? client}) : httpClient = client ?? http.Client();

  Future<List<Category>> getCategories() async {
    try {
      final response =
          await httpClient.get(Uri.parse('$_baseUrl/categories.php'));

      // Print the response status and body for debugging
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

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
      final response = await http.get(Uri.parse('$_baseUrl/products.php'));

      if (response.statusCode == 200) {
        // Print the response body for debugging
        print('Response body: ${response.body}');

        // Decode the response body into a list
        final List<dynamic> jsonList = json.decode(response.body);

        // Map the JSON list to Product objects
        return jsonList
            .map((json) {
              try {
                return Product.fromJson(json);
              } catch (e) {
                print('Error parsing product: $e');
                return null; // or handle accordingly
              }
            })
            .where((product) => product != null)
            .cast<Product>()
            .toList(); // Filter out nulls
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
