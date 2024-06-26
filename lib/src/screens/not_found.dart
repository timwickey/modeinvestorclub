import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text(
          '404 - Page Not Found',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
