import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_profile.dart';

/// Keeps the profile for the current app session only.
/// TODO: replace with on-device storage so the profile survives restarts.
class InMemoryProfileRepository implements ProfileRepository {
  UserProfile? _profile;

  @override
  UserProfile? read() => _profile;

  @override
  Future<void> save(UserProfile profile) async => _profile = profile;
}
