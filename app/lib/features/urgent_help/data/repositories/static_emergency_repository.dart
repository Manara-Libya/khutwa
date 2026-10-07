import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';

/// Contacts compiled into the app, so the urgent screen works offline.
class StaticEmergencyRepository implements EmergencyRepository {
  const StaticEmergencyRepository(this.contacts);

  /// TODO(#62): nothing is verified yet. Add only numbers a teammate has
  /// called and confirmed, with the date (content/verified-contacts.md).
  static const verified = <EmergencyContact>[];

  /// For demos and rehearsals only. These numbers reach nobody, and the
  /// screen labels them as not real. Never include them in a real build.
  static const demo = <EmergencyContact>[
    EmergencyContact.demo(
      name: 'خط الدعم النفسي',
      number: '0000000001',
      description: 'دعم نفسي واستماع',
    ),
    EmergencyContact.demo(
      name: 'الإسعاف',
      number: '0000000002',
      description: 'حالات طبية طارئة',
    ),
  ];

  @override
  final List<EmergencyContact> contacts;
}
