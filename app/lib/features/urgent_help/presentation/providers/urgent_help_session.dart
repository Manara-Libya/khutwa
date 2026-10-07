import '../../domain/entities/emergency_contact.dart';

abstract interface class UrgentHelpSession {
  /// Opens the phone dialer with [contact]'s number. Returns false if it
  /// couldn't.
  Future<bool> call(EmergencyContact contact);

  /// Copies the fixed "I need you" message for the user to send themselves.
  Future<void> copyMessage(String text);
}
