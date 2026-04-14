import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../session/session_controller.dart';
import '../../session/session_state.dart';
import '../../session/widgets/session_countdown_widget.dart';

class FeatureSelectScreen extends ConsumerStatefulWidget {
  const FeatureSelectScreen({super.key});

  @override
  ConsumerState<FeatureSelectScreen> createState() =>
      _FeatureSelectScreenState();
}

class _FeatureSelectScreenState extends ConsumerState<FeatureSelectScreen> {
  /// Ticks every second so the displayed remaining time stays current.
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      // Only rebuild when a session is actively counting down.
      if (mounted && ref.read(sessionControllerProvider).isActive) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    final isActive = session.status == SessionStatus.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Fitur AI'),
        actions: const [SessionCountdownWidget()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ----- Session info banner ------------------------------------
            _SessionInfoBanner(session: session, isActive: isActive),
            const SizedBox(height: 32),

            // ----- Feature options ----------------------------------------
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

/// Prominent session indicator shown at the top of the feature-select body.
///
/// Displays Session ID and live remaining time when a session is active.
/// Shows a "no active session" warning otherwise.
class _SessionInfoBanner extends StatelessWidget {
  const _SessionInfoBanner({
    required this.session,
    required this.isActive,
  });

  final SessionState session;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Colors.green.shade50 : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: isActive ? _ActiveInfo(session: session) : const _NoSessionInfo(),
      ),
    );
  }
}

class _ActiveInfo extends StatelessWidget {
  const _ActiveInfo({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final remaining = session.remainingDuration;
    final label = formatSessionRemaining(remaining);
    final isUrgent = remaining.inSeconds < 60;

    return Column(
      children: [
        const Icon(Icons.verified_user_outlined,
            color: Colors.green, size: 36),
        const SizedBox(height: 8),
        Text(
          'Sesi Aktif',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ID: ${session.sessionId ?? '—'}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 20,
              color: isUrgent ? Colors.red : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              'Sisa: $label',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isUrgent ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NoSessionInfo extends StatelessWidget {
  const _NoSessionInfo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 36),
        SizedBox(height: 8),
        Text(
          'No active session',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Silakan masukkan PIN terlebih dahulu.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}