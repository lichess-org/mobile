import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_preferences.dart';

import '../../test_container.dart';

void main() {
  group('CoordinateTrainingController score persistence', () {
    test('finishing training saves the score for the played side', () async {
      final container = await makeContainer();
      // The controller is autoDispose: keep it alive for the duration of the test.
      final sub = container.listen(coordinateTrainingControllerProvider, (_, _) {});

      await container
          .read(coordinateTrainingPreferencesProvider.notifier)
          .setSideChoice(SideChoice.white);

      final controller = container.read(coordinateTrainingControllerProvider.notifier);
      controller.startTraining(const Duration(milliseconds: 100));
      controller.guessCoordinate(
        container.read(coordinateTrainingControllerProvider).currentCoord!,
      );
      expect(container.read(coordinateTrainingControllerProvider).score, 1);

      // The controller measures elapsed time with a real [Stopwatch], so training only
      // finishes once real time has passed its 100ms limit.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(container.read(coordinateTrainingControllerProvider).trainingActive, isFalse);
      expect(container.read(coordinateTrainingControllerProvider).lastScore, 1);

      final prefs = container.read(coordinateTrainingPreferencesProvider);
      expect(prefs.scores.white, [1]);
      expect(prefs.scores.averageWhite, 1.0);
      expect(prefs.scores.black, isEmpty);

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

      expect(container.read(coordinateTrainingControllerProvider).trainingActive, isFalse);
      expect(
        container.read(coordinateTrainingPreferencesProvider).scores,
        CoordinateScores.defaults,
      );

      sub.close();
    });
  });
}
