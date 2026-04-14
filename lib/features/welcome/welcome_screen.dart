import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AI Photobooth',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(RoutePaths.pin),
                  child: const Text('Mulai'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(RoutePaths.operatorPanel),
                  child: const Text('Operator Panel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}