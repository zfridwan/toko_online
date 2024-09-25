import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

import '../bloc/products/products_bloc.dart';
import '../bloc/products/products_event.dart';
import '../bloc/products/products_state.dart';
import '../models/product-model.dart';
import 'cart-screen.dart';
import 'product-detail-screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  int? _selectedCategoryId;
  List<Product> _filteredProducts = [];
  bool _isLoading = false; // Track loading state
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    BlocProvider.of<CategoryBloc>(context).add(FetchCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set background color to blue
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Searching...',
                  hintStyle: TextStyle(
                      color: Colors.white), // Change hint text color to white
                  prefixIcon: Icon(Icons.search,
                      color: Colors.white), // Change prefix icon color to white
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    color: Colors.white), // Change text input color to white
              )
            : const Text(
                'Toko Online',
                style: TextStyle(
                    color: Colors.white), // Change title text color to white
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart,
                color:
                    Colors.white), // Change shopping cart icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, productState) {
          if (productState is ProductLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (productState is ProductLoaded) {
            _filteredProducts = productState.products
                .where((product) => product.category.id == _selectedCategoryId)
                .toList();
            setState(() {
              _isLoading = false;
            });
          } else if (productState is ProductError) {
            setState(() {
              _isLoading = false;
            });
            print('Error loading products: ${productState.message}');
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              if (_selectedCategoryId == null && state.categories.isNotEmpty) {
                _selectedCategoryId = state.categories.first.id;
                BlocProvider.of<ProductBloc>(context).add(FetchProducts());
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  int crossAxisCount = screenWidth > 900
                      ? 4
                      : screenWidth > 600
                          ? 3
                          : 2;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: state.categories.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: state.categories.map((category) {
                                      return GestureDetector(
                                        onTap: () {
                                          _onCategorySelected(category.id);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  category.image,
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Icon(
                                                      Icons.image_not_supported,
                                                      size: 80,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  category.name,
                                                  style: TextStyle(
                                                    fontSize: screenWidth > 600
                                                        ? 16
                                                        : 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Loading indicator or product grid
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredProducts.isNotEmpty
                                ? SizedBox(
                                    height:
                                        300, // Limiting the height of the GridView
                                    child: GridView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: _filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            _filteredProducts[index];
                                        return Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                    product: product,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(15.0),
                                                  ),
                                                  child: Image.network(
                                                    product.image,
                                                    height: 100,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 100,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.title,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 16
                                                                  : 14,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        '\Rp.${product.price}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 14
                                                                  : 12,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child:
                                        Text('Tidak ada produk yang tersedia'),
                                  ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is CategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    // Fetch products for the selected category
    BlocProvider.of<ProductBloc>(context).add(FetchProducts());
  }
}
