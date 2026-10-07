import 'package:flutter/services.dart';

abstract interface class ClipboardService {
  Future<void> copy(String text);
}

class SystemClipboardService implements ClipboardService {
  const SystemClipboardService();

  @override
  Future<void> copy(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
