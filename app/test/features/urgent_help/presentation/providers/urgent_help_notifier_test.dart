import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/platform/phone_dialer.dart';
import 'package:khutwa_app/core/platform/platform_providers.dart';
import 'package:khutwa_app/features/urgent_help/data/repositories/static_emergency_repository.dart';
import 'package:khutwa_app/features/urgent_help/domain/entities/verified_contact.dart';
import 'package:khutwa_app/features/urgent_help/presentation/providers/urgent_help_repository_provider.dart';

class _FakePhoneDialer implements PhoneDialer {
  _FakePhoneDialer({required this.succeeds});

  final bool succeeds;
  String? dialed;

  @override
  Future<bool> dial(String number) async {
    dialed = number;
    return succeeds;
  }
}

void main() {
  final contact = VerifiedContact(
    name: 'Test line',
    number: '0000',
    verifiedOn: DateTime(2026, 10, 1),
  );

  ProviderContainer containerWith(
    PhoneDialer dialer, {
    List<VerifiedContact> contacts = const [],
  }) => ProviderContainer.test(
    overrides: [
      emergencyRepositoryProvider.overrideWithValue(
        StaticEmergencyRepository(contacts),
      ),
      phoneDialerProvider.overrideWithValue(dialer),
    ],
  );

  test('ships with no unverified numbers (#55, #62)', () {
    expect(StaticEmergencyRepository.verified, isEmpty);
  });

  test('exposes verified contacts and dials the chosen one', () async {
    final dialer = _FakePhoneDialer(succeeds: true);
    final container = containerWith(dialer, contacts: [contact]);

    expect(container.read(urgentHelpProvider), [contact]);
    expect(
      await container.read(urgentHelpProvider.notifier).call(contact),
      isTrue,
    );
    expect(dialer.dialed, '0000');
  });

  test('reports when the dialer cannot open', () async {
    final container = containerWith(_FakePhoneDialer(succeeds: false));
    expect(
      await container.read(urgentHelpProvider.notifier).call(contact),
      isFalse,
    );
  });
}
