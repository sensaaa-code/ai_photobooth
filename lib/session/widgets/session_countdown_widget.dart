import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session_controller.dart';
import '../session_state.dart';

/// Displays a live countdown showing how much session time remains.
///
/// Rebuilds every second while the session is active.
/// Shows nothing (empty widget) when there is no active session.
///
/// Usage — put it in an AppBar or anywhere in the widget tree:
/// ```dart
/// appBar: AppBar(
///   title: const Text('My Screen'),
///   actions: const [SessionCountdownWidget()],
/// ),
/// ```
class SessionCountdownWidget extends ConsumerStatefulWidget {
  const SessionCountdownWidget({super.key});

  @override
  ConsumerState<SessionCountdownWidget> createState() =>
      _SessionCountdownWidgetState();
}

class _SessionCountdownWidgetState
    extends ConsumerState<SessionCountdownWidget> {
  /// Fires every second to refresh the displayed time.
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    // Rebuild the widget every second so the countdown stays up-to-date.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);

    // Only show the countdown while a session is running.
    if (session.status != SessionStatus.active) return const SizedBox.shrink();

    final remaining = session.remainingDuration;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final label = '$minutes:$seconds';

    // Turn red when less than 1 minute remains.
    final isUrgent = remaining.inSeconds < 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: isUrgent ? Colors.red : null,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isUrgent ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
