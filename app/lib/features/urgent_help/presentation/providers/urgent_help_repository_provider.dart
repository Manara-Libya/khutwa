import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';
import 'urgent_help_notifier.dart';

/// Bound to a concrete implementation in `app/bootstrap.dart`.
final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => throw UnimplementedError(
    'Override emergencyRepositoryProvider in bootstrap',
  ),
);

final urgentHelpProvider =
    NotifierProvider<UrgentHelpNotifier, List<EmergencyContact>>(
      UrgentHelpNotifier.new,
    );
