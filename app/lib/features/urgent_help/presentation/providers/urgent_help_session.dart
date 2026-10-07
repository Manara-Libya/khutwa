import '../../domain/entities/verified_contact.dart';

abstract interface class UrgentHelpSession {
  /// Opens the dialer for [contact]. Returns false if it couldn't.
  Future<bool> call(VerifiedContact contact);
}
