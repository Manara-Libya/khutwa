import '../../../app/l10n/l10n.dart';
import '../domain/entities/analysis_result.dart';
import '../domain/entities/support_type.dart';

extension AnalysisL10n on AppLocalizations {
  /// Arabic labels fixed in #54.
  String supportTypeLabel(SupportType type) => switch (type) {
    SupportType.trustedFriend => supportTypeTrustedFriend,
    SupportType.academicAdviser => supportTypeAcademicAdviser,
    SupportType.trustedRelative => supportTypeTrustedRelative,
    SupportType.communityFigure => supportTypeCommunityFigure,
    SupportType.specialist => supportTypeSpecialist,
  };

  /// Generic support options for `fallback: true` responses (#54).
  /// TODO(#62): replace with the reviewed texts.
  List<SupportSuggestion> get genericSupportOptions => [
    SupportSuggestion(
      type: SupportType.trustedFriend,
      why: fallbackWhyFriend,
      draft: fallbackDraftFriend,
    ),
    SupportSuggestion(
      type: SupportType.trustedRelative,
      why: fallbackWhyRelative,
      draft: fallbackDraftRelative,
    ),
    SupportSuggestion(
      type: SupportType.specialist,
      why: fallbackWhySpecialist,
      draft: fallbackDraftSpecialist,
    ),
  ];
}
