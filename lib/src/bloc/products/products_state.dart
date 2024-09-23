import 'package:equatable/equatable.dart';
import '../../models/product-model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products; // Declare the products variable

  const ProductLoaded(
      {required this.products}); // Accept it as a named parameter

  @override
  List<Object?> get props => [products]; // Add products to props for Equatable
}

class ProductError extends ProductState {
  final String message;

  const ProductError(
      {required this.message}); // Ensure message is also a named parameter

  @override
  List<Object?> get props => [message];
}
