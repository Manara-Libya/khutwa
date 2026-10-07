/// A number shown on the urgent-help screen.
///
/// Real builds show only numbers the team verified by phone (#62). Demo
/// builds may also show [isDemo] numbers, which reach nobody and are always
/// labelled as not real.
class EmergencyContact {
  const EmergencyContact({
    required this.name,
    required this.number,
    this.description,
    this.verifiedOn,
  }) : isDemo = false;

  /// A placeholder number for demos and rehearsals only.
  const EmergencyContact.demo({
    required this.name,
    required this.number,
    this.description,
  }) : verifiedOn = null,
       isDemo = true;

  final String name;
  final String number;

  /// What the service offers, if known.
  final String? description;

  /// When a teammate called and someone answered. Null for demo numbers.
  final DateTime? verifiedOn;
  final bool isDemo;
}
