/// The fixed support list from the backend (`SupportType` in schemas.py).
enum SupportType {
  trustedFriend('trusted_friend'),
  academicAdviser('academic_adviser'),
  trustedRelative('trusted_relative'),
  communityFigure('community_figure'),
  specialist('specialist');

  const SupportType(this.apiValue);

  final String apiValue;

  static SupportType? fromApi(String value) =>
      values.where((t) => t.apiValue == value).firstOrNull;
}
