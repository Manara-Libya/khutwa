enum Feeling { stressed, anxious, sad, angry, lonely, unclear }

/// What Khutwa understood from the conversation.
class Reflection {
  const Reflection({required this.topic, required this.feeling});

  /// What takes up most of the user's time, in their own words.
  final String topic;
  final Feeling feeling;

  @override
  bool operator ==(Object other) =>
      other is Reflection && other.topic == topic && other.feeling == feeling;

  @override
  int get hashCode => Object.hash(topic, feeling);
}
