import '../entities/emergency_contact.dart';

abstract interface class EmergencyRepository {
  /// Numbers for the urgent-help screen: verified ones (#62), plus clearly
  /// labelled demo numbers in demo builds. Empty means the screen says
  /// honestly that no number is verified yet.
  List<EmergencyContact> get contacts;
}
