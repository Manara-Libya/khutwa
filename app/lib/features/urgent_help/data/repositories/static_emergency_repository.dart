import '../../domain/entities/verified_contact.dart';
import '../../domain/repositories/emergency_repository.dart';

/// Contacts compiled into the app, so the urgent screen works offline.
class StaticEmergencyRepository implements EmergencyRepository {
  const StaticEmergencyRepository(this.verifiedContacts);

  /// TODO(#62): nothing is verified yet. Add only numbers the team has
  /// called and confirmed, with the date.
  static const verified = <VerifiedContact>[];

  @override
  final List<VerifiedContact> verifiedContacts;
}
