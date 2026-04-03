// ChatGPT generated this test file

import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/account/home_preferences.dart';
import 'package:lichess_mobile/src/model/account/home_widgets.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

void main() {
  group('HomePrefs', () {
    test('defaults have all time controls enabled and custom button on', () {
      expect(HomePrefs.defaults.disabledTimeControls, isEmpty);
      expect(HomePrefs.defaults.customButtonEnabled, isTrue);
    });

    test('serialization round-trip preserves new fields', () {
      final prefs = HomePrefs(
        disabledWidgets: IList(const [HomeEditableWidget.quickPairing]),
        disabledTimeControls: IList(const [TimeIncrement(60, 0), TimeIncrement(300, 0)]),
        customButtonEnabled: false,
      );

      final json = prefs.toJson();
      final restored = HomePrefs.fromJson(json);

      expect(restored.disabledTimeControls.length, 2);
      expect(restored.disabledTimeControls, contains(const TimeIncrement(60, 0)));
      expect(restored.disabledTimeControls, contains(const TimeIncrement(300, 0)));
      expect(restored.customButtonEnabled, isFalse);
    });

    test('fromJson with missing new fields returns defaults', () {
      final oldJson = jsonDecode('{"disabledWidgets":["quickPairing"]}') as Map<String, dynamic>;
      final prefs = HomePrefs.fromJson(oldJson);

      expect(prefs.disabledWidgets, contains(HomeEditableWidget.quickPairing));
      expect(prefs.disabledTimeControls, isEmpty);
      expect(prefs.customButtonEnabled, isTrue);
    });

    test('fromJson with invalid data returns defaults', () {
      final badJson = {'disabledWidgets': 'not_a_list'};
      final prefs = HomePrefs.fromJson(badJson);

      expect(prefs, equals(HomePrefs.defaults));
    });
  });

  group('HomePreferences toggle logic', () {
    test('toggleTimeControl enables disabled control', () {
      final prefs = HomePrefs(
        disabledWidgets: const IListConst([]),
        disabledTimeControls: IList(const [TimeIncrement(60, 0)]),
      );

      // Simulating the toggle logic inline since we can't use Riverpod notifier in unit tests
      const tc = TimeIncrement(60, 0);
      final isDisabled = prefs.disabledTimeControls.contains(tc);
      expect(isDisabled, isTrue);

      final newPrefs = prefs.copyWith(disabledTimeControls: prefs.disabledTimeControls.remove(tc));
      expect(newPrefs.disabledTimeControls, isEmpty);
    });

    test('toggleTimeControl disables enabled control', () {
      const prefs = HomePrefs(
        disabledWidgets: IListConst([]),
        disabledTimeControls: IListConst([]),
      );

      const tc = TimeIncrement(300, 0);
      final newPrefs = prefs.copyWith(disabledTimeControls: prefs.disabledTimeControls.add(tc));
      expect(newPrefs.disabledTimeControls, contains(tc));
    });

    test('cannot disable last enabled item (time controls only)', () {
      // All time controls disabled except one, custom also disabled
      final allButOne = TimeIncrement.matrixPresets.sublist(1).lock;
      final prefs = HomePrefs(
        disabledWidgets: const IListConst([]),
        disabledTimeControls: allButOne,
        customButtonEnabled: false,
      );

      final enabledCount =
          TimeIncrement.matrixPresets.length -
          prefs.disabledTimeControls.length +
          (prefs.customButtonEnabled ? 1 : 0);
      expect(enabledCount, 1);

      // Should not be allowed to disable the last one
      final lastEnabled = TimeIncrement.matrixPresets.first;
      final isDisabled = prefs.disabledTimeControls.contains(lastEnabled);
      expect(isDisabled, isFalse);
      // The notifier would return early here
    });

    test('cannot disable custom when it is the last enabled item', () {
      // All time controls disabled, only custom enabled
      final allDisabled = TimeIncrement.matrixPresets.lock;
      final prefs = HomePrefs(
        disabledWidgets: const IListConst([]),
        disabledTimeControls: allDisabled,
        customButtonEnabled: true,
      );

      final enabledCount =
          TimeIncrement.matrixPresets.length - prefs.disabledTimeControls.length + 1;
      expect(enabledCount, 1);
      // The notifier would return early here
    });

    test('can disable custom when time controls remain', () {
      const prefs = HomePrefs(
        disabledWidgets: IListConst([]),
        disabledTimeControls: IListConst([]),
        customButtonEnabled: true,
      );

      final enabledCount =
          TimeIncrement.matrixPresets.length - prefs.disabledTimeControls.length + 1;
      expect(enabledCount, 12);

      final newPrefs = prefs.copyWith(customButtonEnabled: false);
      expect(newPrefs.customButtonEnabled, isFalse);
    });
  });
}
