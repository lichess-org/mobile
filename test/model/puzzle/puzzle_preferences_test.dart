import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../test_container.dart';

void main() {
  group('PuzzlePreferences', () {
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
