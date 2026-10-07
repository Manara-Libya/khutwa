import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/platform_providers.dart';
import '../../domain/entities/verified_contact.dart';
import 'urgent_help_repository_provider.dart';
import 'urgent_help_session.dart';

/// State: the verified contacts to show. No AI involved, no network needed.
class UrgentHelpNotifier extends Notifier<List<VerifiedContact>>
    implements UrgentHelpSession {
  @override
  List<VerifiedContact> build() =>
      ref.read(emergencyRepositoryProvider).verifiedContacts;

  @override
  Future<bool> call(VerifiedContact contact) =>
      ref.read(phoneDialerProvider).dial(contact.number);
}
