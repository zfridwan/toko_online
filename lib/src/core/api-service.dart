import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/category-model.dart';
import '../models/product-model.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.0.10:3000';
  final http.Client httpClient;

  ApiService({http.Client? client}) : httpClient = client ?? http.Client();

  Future<String?> _fetchApiKey() async {
    try {
      final response = await httpClient.get(Uri.parse('$_baseUrl/api-keys'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['api_key'] as String;
        }
      } else {
        print('Failed to load API keys: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API key: $e');
    }
    return null;
  }

  Future<Map<String, String>> _getHeaders() async {
    String? apiKey = await _fetchApiKey();
    return {
      'Content-Type': 'application/json',
      'api_key': apiKey ?? '',
    };
  }

  Future<List<Category>> getCategories() async {
    try {
      final headers = await _getHeaders();
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/categories'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/products'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/products?categoryId=$categoryId'),
        headers: headers,
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

  Future<User> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to sign up: ${response.body}');
    }

    final data = jsonDecode(response.body);
    if (data['email'] == null) {
      throw Exception('Email not returned in response');
    }

    return User(email: data['email']);
  }

  Future<String> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signIn'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sign in: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['email'];
  }
}
