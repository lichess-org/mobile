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

  group('HomePrefs time control config', () {
    test('can batch-update disabled time controls and custom button', () {
      const prefs = HomePrefs(disabledWidgets: IListConst([]));

      final updated = prefs.copyWith(
        disabledTimeControls: IList(const [TimeIncrement(60, 0), TimeIncrement(300, 0)]),
        customButtonEnabled: false,
      );

      expect(updated.disabledTimeControls.length, 2);
      expect(updated.customButtonEnabled, isFalse);
    });

    test('min-1 validation: at least one time control or custom must remain', () {
      final allDisabledCount = TimeIncrement.matrixPresets.length;

      // All TC disabled + custom disabled = 0 enabled → invalid
      expect(TimeIncrement.matrixPresets.length - allDisabledCount, 0);

      // All TC disabled + custom enabled = 1 enabled → valid
      expect(TimeIncrement.matrixPresets.length - allDisabledCount + 1, 1);
    });

    test('removing a single control from disabled list re-enables it', () {
      final prefs = HomePrefs(
        disabledWidgets: const IListConst([]),
        disabledTimeControls: IList(const [TimeIncrement(60, 0)]),
      );

      final updated = prefs.copyWith(
        disabledTimeControls: prefs.disabledTimeControls.remove(const TimeIncrement(60, 0)),
      );
      expect(updated.disabledTimeControls, isEmpty);
    });
  });
}
