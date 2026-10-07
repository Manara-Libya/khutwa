/// An emergency contact the team verified by phone (#62).
class VerifiedContact {
  const VerifiedContact({
    required this.name,
    required this.number,
    required this.verifiedOn,
  });

  final String name;
  final String number;
  final DateTime verifiedOn;
}
