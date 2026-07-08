import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

import '../../test_container.dart';
import '../../view/puzzle/example_data.dart';

void main() {
  test('loadForReview keeps the puzzle in view mode past the first-move delay', () async {
    final container = await makeContainer();

    final context = PuzzleContext(
      puzzle: puzzle,
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      userId: null,
      isPuzzleStreak: true,
    );
    final provider = puzzleControllerProvider(context);
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);

    container.read(provider.notifier).loadForReview(context);
    expect(container.read(provider).mode, PuzzleMode.view);

    // The opponent's first move is scheduled 1s after a context is loaded for
    // play. A reviewed puzzle must stay in view mode rather than flipping to
    // play mode.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    expect(container.read(provider).mode, PuzzleMode.view);
  });
}
