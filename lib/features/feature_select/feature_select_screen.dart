import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';

class FeatureSelectScreen extends StatelessWidget {
  const FeatureSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Fitur AI')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mode A: Overlay kacamata (post-processing)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.photoSession),
              child: const Text('Pilih Mode A → Mulai Foto'),
            ),
          ],
        ),
      ),
    );
  }
}