import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';

import '../../test_container.dart';

void main() {
  group('CoordinateScores', () {
    test('defaults are empty lists and null averages', () {
      const scores = CoordinateScores.defaults;
      expect(scores.white, isEmpty);
      expect(scores.black, isEmpty);
      expect(scores.averageWhite, isNull);
      expect(scores.averageBlack, isNull);
    });

    test('addScore appends score to the correct side', () {
      var scores = CoordinateScores.defaults;
      scores = scores.addScore(side: Side.white, score: 10);
      scores = scores.addScore(side: Side.white, score: 20);
      scores = scores.addScore(side: Side.black, score: 15);

      expect(scores.white, [10, 20]);
      expect(scores.black, [15]);
      expect(scores.averageWhite, 15.0);
      expect(scores.averageBlack, 15.0);
    });

    test('addScore limits scores to the last 20 scores per side', () {
      var scores = CoordinateScores.defaults;
      for (int i = 1; i <= 25; i++) {
        scores = scores.addScore(side: Side.white, score: i);
      }

      expect(scores.white.length, kMaxCoordinateScoresCount);
      expect(scores.white.first, 6);
      expect(scores.white.last, 25);
    });
  });

  group('CoordinateTrainingPrefs serialization', () {
    test('round-trip preserves scores', () {
      final prefs = CoordinateTrainingPrefs.defaults.copyWith(
        scores: CoordinateScores(white: IList(const [10, 20, 30]), black: IList(const [15, 25])),
      );

      final json = prefs.toJson();
      final restored = CoordinateTrainingPrefs.fromJson(json);

      expect(restored.scores.white, [10, 20, 30]);
      expect(restored.scores.black, [15, 25]);
      expect(restored.scores.averageWhite, 20.0);
      expect(restored.scores.averageBlack, 20.0);
    });

    test('fromJson with legacy format (missing scores) defaults to empty scores', () {
      final legacyJson = <String, dynamic>{
        'showCoordinates': true,
        'showPieces': false,
        'mode': 'findSquare',
        'timeChoice': 'thirtySeconds',
        'sideChoice': 'white',
      };

      final prefs = CoordinateTrainingPrefs.fromJson(legacyJson);

      expect(prefs.showCoordinates, isTrue);
      expect(prefs.showPieces, isFalse);
      expect(prefs.scores, CoordinateScores.defaults);
      expect(prefs.scores.averageWhite, isNull);
    });
  });

  group('CoordinateTrainingPreferences notifier', () {
    test('addScore persists score to preferences', () async {
      final container = await makeContainer();
      final notifier = container.read(coordinateTrainingPreferencesProvider.notifier);

      expect(container.read(coordinateTrainingPreferencesProvider).scores.white, isEmpty);

      await notifier.addScore(side: Side.white, score: 12);

      expect(container.read(coordinateTrainingPreferencesProvider).scores.white, [12]);
      expect(container.read(coordinateTrainingPreferencesProvider).scores.averageWhite, 12.0);

      await notifier.addScore(side: Side.black, score: 18);

      expect(container.read(coordinateTrainingPreferencesProvider).scores.black, [18]);
      expect(container.read(coordinateTrainingPreferencesProvider).scores.averageBlack, 18.0);
    });

    test('overlapping addScore calls both land', () async {
      final container = await makeContainer();
      final notifier = container.read(coordinateTrainingPreferencesProvider.notifier);

      // Two sessions ending before the first write completes must not clobber each other.
      final first = notifier.addScore(side: Side.white, score: 10);
      final second = notifier.addScore(side: Side.white, score: 18);
      await Future.wait([first, second]);

      final scores = container.read(coordinateTrainingPreferencesProvider).scores;
      expect(scores.white, [10, 18]);
    });

    test('scores survive the real storage round trip and keep only the last 20', () async {
      final container = await makeContainer();
      final notifier = container.read(coordinateTrainingPreferencesProvider.notifier);

      // 21 sessions: the oldest score must be evicted by the cap.
      for (int score = 1; score <= 21; score++) {
        await notifier.addScore(side: Side.white, score: score);
      }

      // A new container reads the preferences back through jsonEncode/jsonDecode.
      final secondContainer = await makeContainer();
      final stored = secondContainer.read(coordinateTrainingPreferencesProvider).scores;

      expect(stored.white.length, kMaxCoordinateScoresCount);
      expect(stored.white.first, 2);
      expect(stored.white.last, 21);
      // Mean of the retained 2..21 window, not of all 21 played sessions.
      expect(stored.averageWhite, 11.5);
      expect(stored.black, isEmpty);
    });
  });
}
