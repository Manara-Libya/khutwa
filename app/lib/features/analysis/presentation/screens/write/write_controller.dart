import 'package:flutter/widgets.dart';

import '../../../../../core/validation/string_validator.dart';

/// Holds what the user is writing. It only stays in memory and is handed to
/// the privacy panel; this screen never calls the network (#54).
class WriteController {
  WriteController({required this._validator});

  final StringValidator _validator;
  final TextEditingController text = TextEditingController();
  final ValueNotifier<String?> error = ValueNotifier(null);

  bool get hasInput => text.text.trim().isNotEmpty;

  /// The text to review, or null if it is empty or invalid.
  String? submit() {
    final value = text.text.trim();
    if (value.isEmpty) return null;
    error.value = _validator(value);
    return error.value == null ? value : null;
  }

  void dispose() {
    text.dispose();
    error.dispose();
  }
}
