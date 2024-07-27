import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget {
  final String? productId;
  const DetailsPage({
    required this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product ID: $productId'),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Back to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
