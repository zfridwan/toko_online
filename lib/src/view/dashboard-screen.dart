import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/src/view/category-list-screen.dart';

import '../bloc/dashboard/dashboard_bloc.dart';
import '../components/loader.dart';
import '../components/spacers.dart';
import '../core/api-service.dart';
import '../models/category-model.dart';
import '../models/product-model.dart';
import 'cart-screen.dart';
import 'product-detail-screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _searchController = TextEditingController();

  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardNav) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return LoadingWidget(
              child: initialLayout(context),
            );
          } else {
            return initialLayout(context);
          }
        },
      ),
    );
  }

  Widget initialLayout(BuildContext context) => const Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: CategoryListScreen(),
            ),
          ],
        ),
      );
}
