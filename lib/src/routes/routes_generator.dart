import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/authentication/auth_bloc.dart';
import '../bloc/products/products_bloc.dart';
import '../core/api-service.dart';
import '../view/category-list-screen.dart';
import '../view/dashboard-screen.dart';
import '../view/sign-in-screen.dart';
import '../view/sign-up-screen.dart';

class RouteGenerator {
  final ApiService _categoryRepository = ApiService();
  final ApiService _productsRepository = ApiService();
  final ApiService _userRepository = ApiService();

  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(_userRepository),
            child: SignInScreen(),
          ),
        );

      case '/signUp': // Add this case for sign up
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(_userRepository),
            child: SignUpScreen(), // Navigate to SignUpScreen
          ),
        );

      case '/dashboard':
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider<DashboardBloc>(
              create: (_) => DashboardBloc(
                  ApiService()), // Create DashboardBloc with ApiService
              child: DashboardScreen(
                  title: "", email: args), // Use email instead of username
            ),
          );
        }
        return _errorRoute();

      case '/category':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CategoryBloc(_categoryRepository),
            child: const CategoryListScreen(),
          ),
        );

      case '/products':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProductBloc(_productsRepository),
            child: const CategoryListScreen(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Navigasi routes error'),
        ),
      );
    });
  }
}
