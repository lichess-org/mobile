import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
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
      return buildScreenRoute(context, screen: const StreakScreen());
    case 'storm':
      return buildScreenRoute(context, screen: const StormScreen());
    case 'study':
      return buildScreenRoute(context, screen: StudyScreen(id: StudyId(id)));
    case 'training':
      return buildScreenRoute(
        context,
        screen: PuzzleScreen(angle: PuzzleAngle.fromKey('mix'), puzzleId: PuzzleId(id)),
      );
    case _:
      {
        final gameId = GameId(appLinkUri.pathSegments[0]);
        final orientation = appLinkUri.pathSegments.getOrNull(2);
        if (gameId.isValid) {
          return buildScreenRoute(
            context,
            screen: ArchivedGameScreen(
              gameId: gameId,
              orientation: orientation == 'black' ? Side.black : Side.white,
            ),
          );
        } else {
          // TODO if it's not a game, it's a challenge.
          // So we should show a accept/decline screen here.
          return null;
        }
      }
  }
}
