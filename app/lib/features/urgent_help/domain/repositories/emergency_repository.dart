import '../entities/verified_contact.dart';

abstract interface class EmergencyRepository {
  /// Only contacts verified by phone, each with its verified-on date (#62).
  /// Empty means the urgent screen shows the generic steps only.
  List<VerifiedContact> get verifiedContacts;
}
