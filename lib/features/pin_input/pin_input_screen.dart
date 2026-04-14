import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../session/session_controller.dart';

/// PIN input screen.
///
/// TODO: replace the placeholder button with a real 4-digit PIN input field
///       that calls the consume-PIN API.
///
/// Right now, pressing "Simulasi PIN benar" generates a session ID from the
/// current timestamp and calls [SessionController.startSession], which starts
/// the 5-minute countdown before navigating to [FeatureSelectScreen].
class PinInputScreen extends ConsumerWidget {
  const PinInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input PIN')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TODO: 4-digit PIN input + consume PIN API'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // --- Simulated PIN consume ---
                // Generate a timestamp-based session ID so each session is
                // unique and the operator can identify it in logs/files.
                final sessionId =
                    'sess_${DateTime.now().millisecondsSinceEpoch}';

                // Start the session (5-minute countdown begins here).
                ref
                    .read(sessionControllerProvider.notifier)
                    .startSession(sessionId);

                // Navigate to feature selection.
                context.go(RoutePaths.featureSelect);
              },
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