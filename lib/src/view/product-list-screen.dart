import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/api-service.dart';
import '../core/mock-database.dart';
import '../model/category-model.dart';
import '../model/product-model.dart';
import 'account-detail-screen.dart';
import 'cart-screen.dart';
import 'product-detail-screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  bool _isSearching = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiService.baseUrl}${ApiService.getCategories}'));
      if (response.statusCode == 200) {
        List<dynamic> categoryList = json.decode(response.body);
        setState(() {
          _categories =
              categoryList.map((json) => Category.fromJson(json)).toList();
          _selectedCategoryId =
              _categories.isNotEmpty ? _categories[0].id : null;
          fetchProducts();
        });
      } else {
        throw Exception('gagal mendapatkan data kategori');
      }
    } catch (e) {
      print('gagal mendapatkan data kategori: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiService.baseUrl}${ApiService.getProduct}'));
      if (response.statusCode == 200) {
        List<dynamic> productList = json.decode(response.body);
        setState(() {
          _products =
              productList.map((json) => Product.fromJson(json)).toList();
          _filteredProducts = _products
              .where((product) => product.category.id == _selectedCategoryId)
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('gagal mendapatkan data produk');
      }
    } catch (e) {
      print('gagal mendapatkan data produk: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.title.toLowerCase().contains(query) &&
              product.category.id == _selectedCategoryId)
          .toList();
    });
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _filteredProducts = _products
          .where((product) => product.category.id == _selectedCategoryId)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Searching...',
                    hintStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.blue),
                )
              : Text('Online Store', style: TextStyle(color: Colors.blue)),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _onSearchChanged();
                  }
                });
              },
              icon: Icon(_isSearching ? Icons.close : Icons.search),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              child: _categories.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              _onCategorySelected(category.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      category.image,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image_not_supported,
                                          size: 80,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: screenWidth > 600 ? 16 : 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: _filteredProducts.map((product) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        product.image,
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.image_not_supported,
                                            size: 100,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    screenWidth > 600 ? 20 : 18,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '\$${product.price}',
                                              style: TextStyle(
                                                fontSize:
                                                    screenWidth > 600 ? 18 : 16,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Exit Aplikasi'),
          content: Text('Anda yakin ingin keluar aplikasi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SystemNavigator.pop();
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}
