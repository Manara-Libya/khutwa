import '../../domain/entities/analysis_result.dart';

/// One line in the conversation.
sealed class ConversationEntry {
  const ConversationEntry();
}

/// What the user wrote, and the redacted text that actually left the phone.
class SentEntry extends ConversationEntry {
  const SentEntry({required this.original, required this.redacted});

  final String original;
  final String redacted;

  bool get wasRedacted => original != redacted;
}

/// The AI's reflection.
class ReplyEntry extends ConversationEntry {
  const ReplyEntry(this.reflection);

  final String reflection;
}

class ConversationState {
  const ConversationState({
    this.entries = const [],
    this.waiting = false,
    this.failed = false,
    this.latest,
  });

  final List<ConversationEntry> entries;

  /// Waiting for the API.
  final bool waiting;

  /// The last request failed; it can be retried.
  final bool failed;

  /// The last analysis. When urgent it carries no AI text.
  final AnalysisResult? latest;

  /// How much the user has written and sent so far.
  int get charactersSent => entries.whereType<SentEntry>().fold(
    0,
    (sum, e) => sum + e.original.length,
  );

  /// Support options can be offered once there is a non-urgent reply.
  bool get canShowOptions => !waiting && latest != null && !latest!.isUrgent;

  ConversationState copyWith({
    List<ConversationEntry>? entries,
    bool? waiting,
    bool? failed,
    AnalysisResult? latest,
  }) => ConversationState(
    entries: entries ?? this.entries,
    waiting: waiting ?? this.waiting,
    failed: failed ?? this.failed,
    latest: latest ?? this.latest,
  );
}
