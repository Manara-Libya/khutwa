import 'package:flutter/widgets.dart';

import '../../../../../core/validation/string_validator.dart';
import '../../providers/onboarding_session.dart';

/// Holds the nickname field and forwards a valid nickname to the session.
class NicknameController {
  NicknameController({
    required this._session,
    required this._validator,
    String initialValue = '',
  }) : text = TextEditingController(text: initialValue);

  final OnboardingSession _session;
  final StringValidator _validator;
  final TextEditingController text;
  final ValueNotifier<String?> error = ValueNotifier(null);

  bool get hasInput => text.text.trim().isNotEmpty;

  /// Validates and saves the nickname. Returns true on success.
  bool submit() {
    final value = text.text.trim();
    error.value = _validator(value);
    if (error.value != null) return false;
    _session.setNickname(value);
    return true;
  }

  void dispose() {
    text.dispose();
    error.dispose();
  }
}
