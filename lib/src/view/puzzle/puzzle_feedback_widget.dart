import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';

class PuzzleFeedbackWidget extends ConsumerWidget {
  const PuzzleFeedbackWidget({super.key, required this.puzzle, required this.state, required this.onStreak});

  final Puzzle puzzle;
  final PuzzleState state;
  final bool onStreak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(boardPreferencesProvider.select((value) => value.pieceSet));
    final boardTheme = ref.watch(boardPreferencesProvider.select((state) => state.boardTheme));
    final brightness = ref.watch(currentBrightnessProvider);

    final piece = state.pov == Side.white ? PieceKind.whiteKing : PieceKind.blackKing;
    final asset = pieceSet.assets[piece]!;

    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating = context.l10n.puzzleRatingX(puzzle.puzzle.rating.toString());
        final playedXTimes = context.l10n.puzzlePlayedXTimes(puzzle.puzzle.plays).localizeNumbers();
        return _FeedbackTile(
          leading:
              state.result == PuzzleResult.win
                  ? Icon(Icons.check, size: 36, color: context.lichessColors.good)
                  : null,
          title:
              onStreak && state.result == PuzzleResult.lose
                  ? const Text(
                    'GAME OVER',
                    style: TextStyle(fontSize: 24, letterSpacing: 2.0),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
                  : Text(
                    state.result == PuzzleResult.win
                        ? context.l10n.puzzlePuzzleSuccess
                        : context.l10n.puzzlePuzzleComplete,
                    overflow: TextOverflow.ellipsis,
                  ),
          subtitle:
              onStreak && state.result == PuzzleResult.lose
                  ? null
                  : RatingPrefAware(
                    orElse: Text('$playedXTimes.', overflow: TextOverflow.ellipsis, maxLines: 2),
                    child: Text(
                      '$puzzleRating. $playedXTimes.',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
        );
      case PuzzleMode.load:
      case PuzzleMode.play:
        if (state.feedback == PuzzleFeedback.bad) {
          return _FeedbackTile(
            leading: Icon(Icons.close, size: 36, color: context.lichessColors.error),
            title: Text(context.l10n.puzzleNotTheMove, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              context.l10n.puzzleTrySomethingElse,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          );
        } else if (state.feedback == PuzzleFeedback.good) {
          return _FeedbackTile(
            leading: Icon(Icons.check, size: 36, color: context.lichessColors.good),
            title: Text(context.l10n.puzzleBestMove),
            subtitle: Text(context.l10n.puzzleKeepGoing),
          );
        } else {
          return _FeedbackTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color:
                    brightness == Brightness.light
                        ? boardTheme.colors.lightSquare
                        : boardTheme.colors.darkSquare,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  asset.assetName,
                  width: 48,
                  height: 48,
                  bundle: asset.bundle,
                  package: asset.package,
                ),
              ),
            ),
            title: Text(context.l10n.yourTurn, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              state.pov == Side.white
                  ? context.l10n.puzzleFindTheBestMoveForWhite
                  : context.l10n.puzzleFindTheBestMoveForBlack,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          );
        }
    }
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({this.leading, required this.title, this.subtitle});

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = DefaultTextStyle.of(context).style.fontSize;

    return Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 16.0)],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: defaultFontSize != null ? defaultFontSize * 1.2 : null,
                  fontWeight: FontWeight.bold,
                ),
                child: title,
              ),
              if (subtitle != null) subtitle!,
            ],
          ),
        ),
      ],
    );
  }
}
