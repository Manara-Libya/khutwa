import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/platform/clipboard_service.dart';
import 'package:khutwa_app/core/platform/phone_dialer.dart';
import 'package:khutwa_app/core/platform/platform_providers.dart';
import 'package:khutwa_app/features/urgent_help/data/repositories/static_emergency_repository.dart';
import 'package:khutwa_app/features/urgent_help/domain/entities/emergency_contact.dart';
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

class _FakeClipboard implements ClipboardService {
  String? text;

  @override
  Future<void> copy(String value) async => text = value;
}

void main() {
  final contact = EmergencyContact(
    name: 'Test line',
    number: '0000',
    verifiedOn: DateTime(2026, 10, 1),
  );

  ProviderContainer containerWith(
    PhoneDialer dialer, {
    List<EmergencyContact> contacts = const [],
    ClipboardService? clipboard,
  }) => ProviderContainer.test(
    overrides: [
      emergencyRepositoryProvider.overrideWithValue(
        StaticEmergencyRepository(contacts),
      ),
      phoneDialerProvider.overrideWithValue(dialer),
      if (clipboard != null)
        clipboardServiceProvider.overrideWithValue(clipboard),
    ],
  );

  test('ships with no unverified real numbers (#55, #62)', () {
    expect(StaticEmergencyRepository.verified, isEmpty);
  });

  test('demo numbers are labelled demo and reach nobody', () {
    expect(StaticEmergencyRepository.demo, isNotEmpty);
    for (final c in StaticEmergencyRepository.demo) {
      expect(c.isDemo, isTrue);
      expect(c.verifiedOn, isNull);
      // All zeros except the last digit: not a real service.
      expect(c.number, matches(RegExp(r'^0{6,}\d$')));
    }
  });

  test('dials the chosen contact', () async {
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

  test('copies the fixed message', () async {
    final clipboard = _FakeClipboard();
    final container = containerWith(
      _FakePhoneDialer(succeeds: true),
      clipboard: clipboard,
    );
    await container.read(urgentHelpProvider.notifier).copyMessage('hi');
    expect(clipboard.text, 'hi');
  });
}
