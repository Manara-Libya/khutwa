import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  /// The saved profile, or null before onboarding is complete.
  UserProfile? read();

  Future<void> save(UserProfile profile);
}
