import '../../../app/l10n/l10n.dart';
import '../../chat/domain/entities/reflection.dart';
import '../../chat/presentation/chat_l10n.dart';
import '../domain/entities/suggestion_kind.dart';

/// Localized text for suggestions and drafts.
extension SupportL10n on AppLocalizations {
  String suggestionTitle(SuggestionKind k) => switch (k) {
    SuggestionKind.trustedAdult => suggestionTrustedAdultTitle,
    SuggestionKind.friend => suggestionFriendTitle,
    SuggestionKind.counselor => suggestionCounselorTitle,
    SuggestionKind.specialist => suggestionSpecialistTitle,
    SuggestionKind.selfNote => suggestionSelfNoteTitle,
  };

  String suggestionDesc(SuggestionKind k) => switch (k) {
    SuggestionKind.trustedAdult => suggestionTrustedAdultDesc,
    SuggestionKind.friend => suggestionFriendDesc,
    SuggestionKind.counselor => suggestionCounselorDesc,
    SuggestionKind.specialist => suggestionSpecialistDesc,
    SuggestionKind.selfNote => suggestionSelfNoteDesc,
  };

  String suggestionWhy(SuggestionKind k, Reflection r) => switch (k) {
    SuggestionKind.trustedAdult => suggestionTrustedAdultWhy(
      feeling(r.feeling),
    ),
    SuggestionKind.friend => suggestionFriendWhy(feeling(r.feeling)),
    SuggestionKind.counselor => suggestionCounselorWhy(r.topic),
    SuggestionKind.specialist => suggestionSpecialistWhy,
    SuggestionKind.selfNote => suggestionSelfNoteWhy,
  };

  String draft(SuggestionKind k, Reflection r, String nickname) {
    final f = feeling(r.feeling);
    return switch (k) {
      SuggestionKind.trustedAdult => draftTrustedAdult(f),
      SuggestionKind.friend => draftFriend(f),
      SuggestionKind.counselor => draftCounselor(f, r.topic),
      SuggestionKind.specialist => draftSpecialist(f),
      SuggestionKind.selfNote => draftSelfNote(nickname, f),
    };
  }
}
