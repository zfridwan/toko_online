import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/auth_bloc.dart';
import '../core/mock-database.dart';

class AccountDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    String? username;

    if (authState is AuthLoaded) {
      username = authState.username;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: username != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${username ?? "Unknown"}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Email: ${username ?? ['email']}'),
                ],
              )
            : Center(child: Text('No user details available')),
      ),
    );
  }
}
