import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/storm_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/streak_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';

Route<dynamic>? resolveAppLinkUri(BuildContext context, Uri appLinkUri) {
  if (appLinkUri.pathSegments.length < 2 || appLinkUri.pathSegments[1].isEmpty) {
    return null;
  }

  final id = appLinkUri.pathSegments[1];

  switch (appLinkUri.pathSegments[0]) {
    case 'streak':
      return StreakScreen.buildRoute(context);
    case 'storm':
      return StormScreen.buildRoute(context);
    case 'study':
      return StudyScreen.buildRoute(context, StudyId(id));
    case 'training':
      return PuzzleScreen.buildRoute(
        context,
        angle: PuzzleAngle.fromKey('mix'),
        puzzleId: PuzzleId(id),
      );
    case _:
      {
        final gameId = GameId(appLinkUri.pathSegments[0]);
        final orientation = appLinkUri.pathSegments.getOrNull(2);
        if (gameId.isValid) {
          return ArchivedGameScreen.buildRoute(
            context,
            gameId: gameId,
            orientation: orientation == 'black' ? Side.black : Side.white,
          );
        } else {
          // TODO if it's not a game, it's a challenge.
          // So we should show a accept/decline screen here.
          return null;
        }
      }
  }
}
