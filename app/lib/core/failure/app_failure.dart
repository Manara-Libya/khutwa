enum FailureKind { network, timeout, unauthorized, server, invalidResponse }

/// An expected failure the UI can explain and offer to retry.
class AppFailure implements Exception {
  const AppFailure(this.kind, [this.detail]);

  final FailureKind kind;

  /// For logs only; never shown to the user and never contains user text.
  final String? detail;

  @override
  String toString() => 'AppFailure($kind${detail == null ? '' : ': $detail'})';
}
