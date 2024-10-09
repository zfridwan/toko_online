import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/products/products_bloc.dart';
import 'src/core/api-service.dart';
import 'src/routes/routes_generator.dart';
import 'src/bloc/category/category_bloc.dart';
import 'src/bloc/authentication/auth_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(apiService),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(apiService),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Toko Online',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator().generateRoute,
      ),
    );
  }
}
