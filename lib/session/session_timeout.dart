import 'dart:async';

/// How long a session lasts before it automatically expires.
const Duration kSessionDuration = Duration(minutes: 5);

/// A simple wrapper around [Timer] that manages the 5-minute session timeout.
///
/// Usage:
/// ```dart
/// final timer = SessionTimer(onTimeout: expireSession);
/// // ... later, if the session finishes normally:
/// timer.cancel();
/// ```
///
/// Disposal is handled by [SessionController] via `ref.onDispose`.
class SessionTimer {
  Timer? _timer;

  /// Creates a new timer that calls [onTimeout] after [kSessionDuration].
  SessionTimer({required void Function() onTimeout}) {
    _timer = Timer(kSessionDuration, onTimeout);
  }

  /// Cancels the timer so [onTimeout] is never called.
  /// Safe to call multiple times.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether the timer is still running.
  bool get isActive => _timer?.isActive ?? false;
}
