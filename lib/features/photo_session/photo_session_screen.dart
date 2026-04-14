import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../session/widgets/session_countdown_widget.dart';

class PhotoSessionScreen extends StatelessWidget {
  const PhotoSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesi Foto (4x)'),
        actions: const [SessionCountdownWidget()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TODO: camera preview + countdown + capture 4 photos (4:5)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.review),
              child: const Text('Simulasi selesai foto → Review'),
            ),
          ],
        ),
      ),
    );
  }
}