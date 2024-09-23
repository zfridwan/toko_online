import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toko_online/src/bloc/products/products_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/authentication/auth_bloc.dart';

import '../core/api-service.dart';
import '../view/category-list-screen.dart';
import '../view/dashboard-screen.dart';
import '../view/sign-in-screen.dart';

class RouteGenerator {
  final AuthBloc _authBloc = AuthBloc();
  final DashboardBloc _dashboardBloc = DashboardBloc();
  final ApiService _categoryRepository = ApiService();
  final ApiService _productsRepository = ApiService();

  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: const SignInScreen(title: "Login page with overlay"),
          ),
        );

      case '/dashboard':
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider<DashboardBloc>.value(
              value: _dashboardBloc,
              child: DashboardScreen(title: "Dashboard", username: args),
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
          child: Text('navigasi routes error'),
        ),
      );
    });
  }
}
