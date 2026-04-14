import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../session/session_controller.dart';
import '../../session/session_state.dart';

/// Operator Panel — accessible at any time, even when the session is expired.
///
/// Shows the last known session status so the operator can diagnose issues,
/// and provides a "Reset session" button to clear state and return to idle.
class OperatorPanelScreen extends ConsumerWidget {
  const OperatorPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Operator Panel')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Session status card -----------------------------------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Sesi Terakhir',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _StatusRow(
                          label: 'Session ID',
                          value: session.sessionId ?? '—',
                        ),
                        _StatusRow(
                          label: 'Status',
                          value: _statusLabel(session.status),
                          valueColor: _statusColor(session.status),
                        ),
                        _StatusRow(
                          label: 'Dimulai',
                          value: session.startedAt != null
                              ? _formatDateTime(session.startedAt!)
                              : '—',
                        ),
                        _StatusRow(
                          label: 'Berakhir',
                          value: session.expiresAt != null
                              ? _formatDateTime(session.expiresAt!)
                              : '—',
                        ),
                        if (session.abortReason != null)
                          _StatusRow(
                            label: 'Alasan abort',
                            value: session.abortReason!,
                          ),
                        if (session.filePaths.isNotEmpty)
                          _StatusRow(
                            label: 'File disimpan',
                            value: '${session.filePaths.length} file(s)',
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- Operator actions -------------------------------------
                const Text(
                  'TODO: status printer/upload/storage + retry + cleanup',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Reset button — clears session state back to idle.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset session (operator)'),
                    onPressed: () {
                      ref
                          .read(sessionControllerProvider.notifier)
                          .resetToIdle();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Session direset ke idle.'),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(RoutePaths.welcome),
                    child: const Text('Kembali ke Welcome'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(SessionStatus status) {
    switch (status) {
      case SessionStatus.idle:
        return 'Idle (tidak ada sesi)';
      case SessionStatus.active:
        return 'Aktif';
      case SessionStatus.expired:
        return 'Kadaluarsa (timeout)';
      case SessionStatus.completed:
        return 'Selesai';
      case SessionStatus.aborted:
        return 'Dibatalkan';
    }
  }

  Color? _statusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return Colors.green;
      case SessionStatus.expired:
        return Colors.red;
      case SessionStatus.aborted:
        return Colors.orange;
      case SessionStatus.completed:
        return Colors.blue;
      case SessionStatus.idle:
        return null;
    }
  }

  String _formatDateTime(DateTime dt) {
    // Simple local format: HH:mm:ss DD/MM/YYYY
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s  ${dt.day}/${dt.month}/${dt.year}';
  }
}

/// A single label-value row used inside the status card.
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}