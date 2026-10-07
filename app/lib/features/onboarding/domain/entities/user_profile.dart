enum AgeGroup { under13, teen, adult }

enum Personality { warm, direct }

enum SupportStyle { selfCare, guided }

class UserProfile {
  const UserProfile({
    this.nickname = '',
    this.ageGroup,
    this.personality,
    this.supportStyle,
  });

  final String nickname;
  final AgeGroup? ageGroup;

  /// Null until chosen; the app talks warmly by default.
  final Personality? personality;
  final SupportStyle? supportStyle;

  Personality get effectivePersonality => personality ?? Personality.warm;

  UserProfile copyWith({
    String? nickname,
    AgeGroup? ageGroup,
    Personality? personality,
    SupportStyle? supportStyle,
  }) => UserProfile(
    nickname: nickname ?? this.nickname,
    ageGroup: ageGroup ?? this.ageGroup,
    personality: personality ?? this.personality,
    supportStyle: supportStyle ?? this.supportStyle,
  );
}
