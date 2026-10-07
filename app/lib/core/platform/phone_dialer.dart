import 'package:url_launcher/url_launcher.dart';

abstract interface class PhoneDialer {
  /// Opens the phone dialer for [number]. Returns false if it couldn't.
  Future<bool> dial(String number);
}

class UrlLauncherPhoneDialer implements PhoneDialer {
  const UrlLauncherPhoneDialer();

  @override
  Future<bool> dial(String number) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: number));
    } catch (_) {
      return false;
    }
  }
}
