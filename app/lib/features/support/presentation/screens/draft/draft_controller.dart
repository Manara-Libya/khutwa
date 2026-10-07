import 'package:flutter/widgets.dart';

import '../../providers/draft_session.dart';

/// Holds the editable draft text and forwards copy requests to the session.
class DraftController {
  DraftController({required this._session, required this.original})
    : text = TextEditingController(text: original);

  final DraftSession _session;

  /// The generated draft, before any edits.
  final String original;
  final TextEditingController text;

  void reset() => text.text = original;

  Future<void> copy() => _session.copy(text.text);

  void dispose() => text.dispose();
}
