import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import '../../binding.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../test_container.dart';

void main() {
  group('offlineQueueLengthForAngle', () {
    const mix = PuzzleTheme(PuzzleThemeKey.mix);

    test('applies the configured count to the mix angle', () {
      expect(isConfigurableOfflineQueueAngle(mix), isTrue);
      expect(offlineQueueLengthForAngle(mix, 250), equals(250));
    });

    test('caps every non-mix angle at kFixedOfflineQueueLength', () {
      for (final angle in const <PuzzleAngle>[
        PuzzleTheme(PuzzleThemeKey.advancedPawn),
        PuzzleTheme(PuzzleThemeKey.opening),
        PuzzleOpening('A00'),
      ]) {
        expect(isConfigurableOfflineQueueAngle(angle), isFalse, reason: '$angle');
        expect(
          offlineQueueLengthForAngle(angle, 300),
          equals(kFixedOfflineQueueLength),
          reason: '$angle',
        );
      }
    });

    test('a full non-mix queue leaves no deficit for the server to fill', () {
      // Regression test for the request burst on the puzzle tab: the fixed queue length must not
      // exceed what one batch request can return, or every saved angle stays permanently short and
      // re-downloads on every read of its next puzzle.
      expect(kFixedOfflineQueueLength, lessThanOrEqualTo(kServerPuzzleBatchCap));
    });
  });

  group('PuzzlePreferences', () {
    test('setNbOfflinePuzzles completes only once the new value is visible', () async {
      // A real preferences write goes through a platform channel, so its future
      // never completes in a microtask: awaiting the setter must still leave the
      // state up to date. The offline queue fill reads the count from there, so
      // a setter that returns early makes the fill top up to the *old* count —
      // a silent no-op when the count was raised.
      TestLichessBinding.ensureInitialized().sharedPreferences = SlowFakeSharedPreferences();

      final container = await makeContainer(authUser: fakeAuthUser);
      // materialize the notifier before the write
      container.read(puzzlePreferencesProvider);

      await container.read(puzzlePreferencesProvider.notifier).setNbOfflinePuzzles(200);

      expect(container.read(puzzlePreferencesProvider).nbOfflinePuzzles, equals(200));
    });

    test('setDifficulty completes only once the new value is visible', () async {
      // Same contract: [PuzzleController.changeDifficulty] awaits this and then
      // refetches the queue, and the batch request reads the difficulty from
      // the state. A setter returning before the state is updated makes that
      // ordering a race against the preferences write.
      TestLichessBinding.ensureInitialized().sharedPreferences = SlowFakeSharedPreferences();

      final container = await makeContainer(authUser: fakeAuthUser);
      container.read(puzzlePreferencesProvider);

      await container.read(puzzlePreferencesProvider.notifier).setDifficulty(.hardest);

      expect(
        container.read(puzzlePreferencesProvider).difficulty,
        equals(PuzzleDifficulty.hardest),
      );
    });

    test('offline queue length is session-scoped: anon reads the default after a '
        'logged-in user increased it', () async {
      // Logged-in user bumps the offline queue length above the default.
      final loggedIn = await makeContainer(authUser: fakeAuthUser);
      await loggedIn
          .read(puzzlePreferencesProvider.notifier)
          .setNbOfflinePuzzles(kMaxOfflinePuzzles);
      expect(loggedIn.read(puzzlePreferencesProvider).nbOfflinePuzzles, equals(kMaxOfflinePuzzles));

      // A new anonymous session shares the same SharedPreferences store but a
      // different (per-user) key, so it must fall back to the default rather
      // than inherit the logged-in user's larger queue.
      final anon = await makeContainer();
      expect(
        anon.read(puzzlePreferencesProvider).nbOfflinePuzzles,
        equals(PuzzlePrefs.defaults().nbOfflinePuzzles),
      );
    });

    test('clamps an out-of-bounds stored value on load', () async {
      final container = await makeContainer(authUser: fakeAuthUser);
      final notifier = container.read(puzzlePreferencesProvider.notifier);

      // Above the max is clamped down...
      await notifier.setNbOfflinePuzzles(9999);
      expect(
        container.read(puzzlePreferencesProvider).nbOfflinePuzzles,
        equals(kMaxOfflinePuzzles),
      );

      // ...and below the min is clamped up.
      await notifier.setNbOfflinePuzzles(1);
      expect(
        container.read(puzzlePreferencesProvider).nbOfflinePuzzles,
        equals(kMinOfflinePuzzles),
      );
    });
  });
}
