import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';

class PinInputScreen extends StatelessWidget {
  const PinInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input PIN')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TODO: 4-digit PIN input + consume PIN API'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.featureSelect),
              child: const Text('Simulasi PIN benar → Lanjut'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(RoutePaths.welcome),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}