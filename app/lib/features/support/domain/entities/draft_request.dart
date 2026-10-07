import '../../../chat/domain/entities/reflection.dart';
import 'suggestion_kind.dart';

/// What the draft screen writes: a message for [kind], based on [reflection].
class DraftRequest {
  const DraftRequest({required this.kind, required this.reflection});

  final SuggestionKind kind;
  final Reflection reflection;
}
