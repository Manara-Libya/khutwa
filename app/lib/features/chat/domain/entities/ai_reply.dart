import 'a2ui_surface.dart';

/// A reply from the AI: text, an A2UI surface, or both.
class AiReply {
  const AiReply({this.text, this.surface});

  final String? text;
  final A2uiSurface? surface;
}
