import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import '../../test_container.dart';
import '../auth/fake_auth_storage.dart';

void main() {
  group('PuzzleSession.addAttempt', () {
    final params = (userId: fakeAuthUser.user.id, angle: const PuzzleTheme(PuzzleThemeKey.mix));
    const first = PuzzleId('pId1');
    const second = PuzzleId('pId2');

    test('a replayed puzzle takes the new result without the first attempt rating diff', () async {
      final container = await makeContainer(authUser: fakeAuthUser);
      final session = container.read(puzzleSessionProvider(params).notifier);

      await session.addAttempt(first, win: true);
      await session.addAttempt(second, win: false);
      await session.setRatingDiffs(const [
        PuzzleRound(id: first, ratingDiff: 8, win: true),
        PuzzleRound(id: second, ratingDiff: -4, win: false),
      ]);

      await session.addAttempt(first, win: false);

      expect(
        container.read(puzzleSessionProvider(params)).attempts,
        equals(
          IList(const [
            PuzzleAttempt(id: first, win: false),
            PuzzleAttempt(id: second, win: false, ratingDiff: -4),
          ]),
        ),
      );
    });
  });
}
