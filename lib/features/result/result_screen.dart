import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../session/session_controller.dart';
import '../../session/widgets/session_countdown_widget.dart';

/// Result screen — shown after strip selection.
///
/// The "Selesai" button marks the session as [SessionStatus.completed]
/// before navigating back to the Welcome screen.
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil & Output'),
        actions: const [SessionCountdownWidget()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TODO: preview strip + print (pdf/printing) + upload queue'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mark session as successfully completed.
                ref
                    .read(sessionControllerProvider.notifier)
                    .markCompleted();

                // Return to the welcome screen for the next guest.
                context.go(RoutePaths.welcome);
              },
              child: const Text('Selesai (kembali ke Welcome)'),
            ),
          ],
        ),
      ),
    );
  }
}