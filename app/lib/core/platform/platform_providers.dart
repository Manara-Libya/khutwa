import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'clipboard_service.dart';
import 'phone_dialer.dart';

final phoneDialerProvider = Provider<PhoneDialer>(
  (ref) => const UrlLauncherPhoneDialer(),
);

final clipboardServiceProvider = Provider<ClipboardService>(
  (ref) => const SystemClipboardService(),
);
