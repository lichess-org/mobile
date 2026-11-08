import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';

import '../../test_container.dart';

/// Runs a timed session that finishes on its own and returns the score it recorded.
///
/// The controller measures elapsed time with a real [Stopwatch], so finishing a session
/// takes real time: the session below is limited to 100ms and waited out.
Future<int> _runSessionUntilFinished(
  ProviderContainer container, {
  required bool withCorrectGuess,
}) async {
  final controller = container.read(coordinateTrainingControllerProvider.notifier);
  controller.startTraining(const Duration(milliseconds: 100));

  if (withCorrectGuess) {
    controller.guessCoordinate(container.read(coordinateTrainingControllerProvider).currentCoord!);
  }

  await Future<void>.delayed(const Duration(milliseconds: 400));

  final state = container.read(coordinateTrainingControllerProvider);
  expect(state.trainingActive, isFalse, reason: 'the timed session should have finished');
  return state.lastScore!;
}

void main() {
  group('CoordinateTrainingController score persistence', () {
    test('finishing training saves the score for the played side', () async {
      final container = await makeContainer();
      // The controller is autoDispose: keep it alive for the duration of the test.
      final sub = container.listen(coordinateTrainingControllerProvider, (_, _) {});

      await container
          .read(coordinateTrainingPreferencesProvider.notifier)
          .setSideChoice(SideChoice.white);

      final score = await _runSessionUntilFinished(container, withCorrectGuess: true);
      expect(score, 1);

      final prefs = container.read(coordinateTrainingPreferencesProvider);
      expect(prefs.scores.white, [1]);
      expect(prefs.scores.averageWhite, 1.0);
      expect(prefs.scores.black, isEmpty);

      sub.close();
    });

    test('a finished session with no correct guess records a score of 0', () async {
      final container = await makeContainer();
      final sub = container.listen(coordinateTrainingControllerProvider, (_, _) {});

      await container
          .read(coordinateTrainingPreferencesProvider.notifier)
          .setSideChoice(SideChoice.white);

      final score = await _runSessionUntilFinished(container, withCorrectGuess: false);
      expect(score, 0);

      final prefs = container.read(coordinateTrainingPreferencesProvider);
      expect(prefs.scores.white, [0]);
      expect(prefs.scores.averageWhite, 0.0);

      sub.close();
    });

    test('a session with a random side choice credits the side that was played', () async {
      final container = await makeContainer();
      final sub = container.listen(coordinateTrainingControllerProvider, (_, _) {});

      await container
          .read(coordinateTrainingPreferencesProvider.notifier)
          .setSideChoice(SideChoice.random);

      // The played side is drawn at random, so play until both sides have come up and check
      // after every session that only the side that was played got credited.
      final sidesPlayed = <Side>{};
      int whiteCount = 0;
      int blackCount = 0;

      for (int attempt = 0; attempt < 10 && sidesPlayed.length < 2; attempt++) {
        final playedSide = container.read(coordinateTrainingControllerProvider).orientation;
        final score = await _runSessionUntilFinished(container, withCorrectGuess: true);
        expect(score, 1);

        if (playedSide == Side.white) {
          whiteCount++;
        } else {
          blackCount++;
        }
        sidesPlayed.add(playedSide);

        final stored = container.read(coordinateTrainingPreferencesProvider).scores;
        expect(stored.white, List.filled(whiteCount, 1), reason: 'white tally after $playedSide');
        expect(stored.black, List.filled(blackCount, 1), reason: 'black tally after $playedSide');
      }

      expect(sidesPlayed, {
        Side.white,
        Side.black,
      }, reason: 'a random side choice should have dealt both orientations');

      sub.close();
    });

    test('aborting training does not save a score', () async {
      final container = await makeContainer();
      final sub = container.listen(coordinateTrainingControllerProvider, (_, _) {});

      await container
          .read(coordinateTrainingPreferencesProvider.notifier)
          .setSideChoice(SideChoice.black);

      final controller = container.read(coordinateTrainingControllerProvider.notifier);
      controller.startTraining(const Duration(seconds: 30));
      controller.guessCoordinate(
        container.read(coordinateTrainingControllerProvider).currentCoord!,
      );
      expect(container.read(coordinateTrainingControllerProvider).score, 1);

      controller.abortTraining();

      // Persistence is fire-and-forget, so let pending saves settle before asserting.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(container.read(coordinateTrainingControllerProvider).trainingActive, isFalse);
      expect(
        container.read(coordinateTrainingPreferencesProvider).scores,
        CoordinateScores.defaults,
        reason: 'an aborted session must not be recorded as a score',
      );

      sub.close();
    });
  });
}
