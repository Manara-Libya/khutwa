import 'package:flutter/widgets.dart';

import '../../../../../core/validation/string_validator.dart';
import '../../providers/conversation_session.dart';

/// Holds the message field and forwards valid messages to the session.
class ConversationController {
  ConversationController({required this._session, required this._validator});

  final ConversationSession _session;
  final StringValidator _validator;
  final TextEditingController text = TextEditingController();
  final ValueNotifier<String?> error = ValueNotifier(null);

  /// Sends the current text. Empty input is ignored; invalid input sets
  /// [error] and is kept so the user can fix it.
  void send() {
    final value = text.text.trim();
    if (value.isEmpty) return;
    error.value = _validator(value);
    if (error.value != null) return;
    text.clear();
    _session.send(value);
  }

  void dispose() {
    text.dispose();
    error.dispose();
  }
}
