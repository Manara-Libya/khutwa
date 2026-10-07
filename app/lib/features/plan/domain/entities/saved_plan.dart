import '../../../analysis/domain/entities/support_type.dart';

/// The plan the user saves at the end of the flow (#55). Lives only on the
/// device. The coping cards are fixed texts (#62), so they aren't stored.
class SavedPlan {
  const SavedPlan({
    required this.supportType,
    required this.supportLabel,
    required this.draft,
    required this.savedAt,
  });

  final SupportType supportType;

  /// The label as shown when the plan was saved.
  final String supportLabel;

  /// The draft as the user edited it.
  final String draft;
  final DateTime savedAt;
}
