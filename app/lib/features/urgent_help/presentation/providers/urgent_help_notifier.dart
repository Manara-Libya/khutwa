import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/platform_providers.dart';
import '../../domain/entities/emergency_contact.dart';
import 'urgent_help_repository_provider.dart';
import 'urgent_help_session.dart';

/// State: the contacts to show. No AI involved, no network needed.
class UrgentHelpNotifier extends Notifier<List<EmergencyContact>>
    implements UrgentHelpSession {
  @override
  List<EmergencyContact> build() =>
      ref.read(emergencyRepositoryProvider).contacts;

  @override
  Future<bool> call(EmergencyContact contact) =>
      ref.read(phoneDialerProvider).dial(contact.number);

  @override
  Future<void> copyMessage(String text) =>
      ref.read(clipboardServiceProvider).copy(text);
}
