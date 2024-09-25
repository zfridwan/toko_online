import 'package:flutter/material.dart';
import '../core/mock-database.dart';

class AccountDetailScreen extends StatelessWidget {
  final String username;

  AccountDetailScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    final user = MockDatabase.getUserDetails(username);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Set background color to blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $username',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Email: ${user['email']}'),
                ],
              )
            : Center(child: Text('User tidak ada')),
      ),
    );
  }
}
