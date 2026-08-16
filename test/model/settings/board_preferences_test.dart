import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

void main() {
  group('premove mode preference', () {
    test('fresh defaults preserve single premove behaviour', () {
      expect(BoardPrefs.defaults.premoveMode, PremoveMode.single);
      expect(BoardPrefs.defaults.premoveMode.maxCount, 1);
    });

    test('old enabled premove preference migrates to single mode', () {
      final json = BoardPrefs.defaults.toJson()
        ..remove('multiplePremoves')
        ..['premoves'] = true;

      final prefs = BoardPrefs.fromJson(json);

      expect(prefs.premoveMode, PremoveMode.single);
      expect(prefs.premoveMode.maxCount, 1);
    });

    test('old disabled premove preference remains disabled', () {
      final json = BoardPrefs.defaults.toJson()
        ..remove('multiplePremoves')
        ..['premoves'] = false;

      final prefs = BoardPrefs.fromJson(json);

      expect(prefs.premoveMode, PremoveMode.disabled);
      expect(prefs.premoveMode.enabled, isFalse);
    });

    test('multiple flag maps enabled storage to multiple mode', () {
      final prefs = BoardPrefs.defaults.copyWith(premoves: true, multiplePremoves: true);

      expect(prefs.premoveMode, PremoveMode.multiple);
      expect(prefs.premoveMode.maxCount, kMultiplePremoveLimit);
    });

    test('disabled mode wins over a stale multiple flag', () {
      final prefs = BoardPrefs.defaults.copyWith(premoves: false, multiplePremoves: true);

      expect(prefs.premoveMode, PremoveMode.disabled);
      expect(prefs.premoveMode.enabled, isFalse);
      expect(prefs.premoveMode.maxCount, 1);
    });
  });
}
