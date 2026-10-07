import 'package:flutter/widgets.dart';

import '../../providers/message_draft_session.dart';

/// Holds the editable draft and forwards copy requests to the session.
class MessageDraftController {
  MessageDraftController({required this._session, required String draft})
    : text = TextEditingController(text: draft);

  final MessageDraftSession _session;
  final TextEditingController text;

  Future<void> copy() => _session.copy(text.text);

  void dispose() => text.dispose();
}
