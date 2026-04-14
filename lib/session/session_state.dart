/// Represents the current status of a photobooth session.
enum SessionStatus {
  /// No session has been started yet (app just opened or reset by operator).
  idle,

  /// A session is in progress — PIN was consumed and timer is running.
  active,

  /// The 5-minute session timer ran out before the user completed the flow.
  expired,

  /// The user reached the result screen and pressed "Selesai".
  completed,

  /// The session was ended early (e.g. operator action or error).
  aborted,
}

/// Immutable model holding all data for the current photobooth session.
///
/// Created when [SessionStatus.idle], then updated as the session progresses.
class SessionState {
  /// Unique identifier for this session (timestamp-based string).
  final String? sessionId;

  /// When the session became active (PIN consumed).
  final DateTime? startedAt;

  /// When the session will expire (startedAt + 5 minutes).
  final DateTime? expiresAt;

  /// Current lifecycle status of the session.
  final SessionStatus status;

  /// Optional: which AI mode the user selected (e.g. 'glasses_overlay').
  final String? selectedMode;

  /// Optional: list of local file paths created during this session.
  /// Preserved on-device for operator review even after expiry.
  final List<String> filePaths;

  /// Optional: reason the session was aborted (for operator review).
  final String? abortReason;

  const SessionState({
    this.sessionId,
    this.startedAt,
    this.expiresAt,
    required this.status,
    this.selectedMode,
    this.filePaths = const [],
    this.abortReason,
  });

  /// Returns true only when a session is actively running.
  bool get isActive => status == SessionStatus.active;

  /// Returns time remaining in the session, or [Duration.zero] if inactive.
  Duration get remainingDuration {
    if (expiresAt == null || !isActive) return Duration.zero;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Returns a new [SessionState] with the specified fields replaced.
  SessionState copyWith({
    String? sessionId,
    DateTime? startedAt,
    DateTime? expiresAt,
    SessionStatus? status,
    String? selectedMode,
    List<String>? filePaths,
    String? abortReason,
  }) {
    return SessionState(
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      selectedMode: selectedMode ?? this.selectedMode,
      filePaths: filePaths ?? this.filePaths,
      abortReason: abortReason ?? this.abortReason,
    );
  }

  @override
  String toString() =>
      'SessionState(id=$sessionId, status=$status, expiresAt=$expiresAt)';
}
