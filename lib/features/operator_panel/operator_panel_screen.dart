import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';

class OperatorPanelScreen extends StatelessWidget {
  const OperatorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operator Panel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TODO: status printer/upload/storage + retry + cleanup'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.welcome),
              child: const Text('Back to Welcome'),
            ),
          ],
        ),
      ),
    );
  }
}