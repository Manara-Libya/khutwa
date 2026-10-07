abstract interface class AnalysisSession {
  /// Calls the API again after a failure.
  void retry();
}
