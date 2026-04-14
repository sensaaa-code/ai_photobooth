import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session_state.dart';
import 'session_timeout.dart';

/// Global provider — use this anywhere in the widget tree to read session state.
///
/// Example (read):
/// ```dart
/// final session = ref.watch(sessionControllerProvider);
/// ```
/// Example (call methods):
/// ```dart
/// ref.read(sessionControllerProvider.notifier).startSession('sess_123');
/// ```
final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

/// Manages the lifecycle of a photobooth session.
///
/// Lifecycle:
///   idle → active (via [startSession]) → completed / aborted / expired
///   Any terminal state → idle (via [resetToIdle], operator only)
class SessionController extends Notifier<SessionState> {
  /// Internal timer; replaced each time a new session starts.
  SessionTimer? _timer;

  @override
  SessionState build() {
    // Ensure timer is cancelled when this notifier is disposed
    // (e.g. hot-restart or provider is overridden in tests).
    ref.onDispose(() => _timer?.cancel());

    return const SessionState(status: SessionStatus.idle);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Starts a new session right after PIN is successfully consumed.
  ///
  /// [sessionId] should be a unique string — use a timestamp-based ID
  /// so the operator can correlate logs/files with a specific session.
  void startSession(String sessionId) {
    // Cancel any leftover timer from a previous (incomplete) session.
    _timer?.cancel();

    final now = DateTime.now();
    final expires = now.add(kSessionDuration);

    state = SessionState(
      sessionId: sessionId,
      startedAt: now,
      expiresAt: expires,
      status: SessionStatus.active,
    );

    // Start the 5-minute countdown.
    // When the timer fires, expireSession() is called automatically.
    _timer = SessionTimer(onTimeout: expireSession);
  }

  /// Call when the user successfully completes the flow ("Selesai" button).
  void markCompleted() {
    _timer?.cancel();
    state = state.copyWith(status: SessionStatus.completed);
  }

  /// Call when the session is ended early (e.g. an error, or operator action).
  void markAborted({String? reason}) {
    _timer?.cancel();
    state = state.copyWith(
      status: SessionStatus.aborted,
      abortReason: reason,
    );
  }

  /// Called automatically by [SessionTimer] after 5 minutes.
  /// Session data is preserved (NOT deleted) for operator review.
  void expireSession() {
    _timer?.cancel();
    // Keep sessionId/startedAt/expiresAt/filePaths intact for operator review.
    state = state.copyWith(status: SessionStatus.expired);
  }

  /// Resets state back to idle. OPERATOR USE ONLY.
  /// Should only be called from the Operator Panel after reviewing the session.
  void resetToIdle() {
    _timer?.cancel();
    state = const SessionState(status: SessionStatus.idle);
  }

  // ---------------------------------------------------------------------------
  // Computed helpers
  // ---------------------------------------------------------------------------

  /// Whether a session is currently running.
  bool get isActive => state.isActive;

  /// Time remaining in the current session, or [Duration.zero] if inactive.
  Duration get remainingDuration => state.remainingDuration;
}
