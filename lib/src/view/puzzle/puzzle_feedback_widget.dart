import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleFeedbackWidget extends ConsumerWidget {
  const PuzzleFeedbackWidget({
    required this.puzzle,
    required this.state,
    required this.onStreak,
  });

  final Puzzle puzzle;
  final PuzzleState state;
  final bool onStreak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((value) => value.pieceSet));

    final piece = state.pov == Side.white
        ? cg.PieceKind.whiteKing
        : cg.PieceKind.blackKing;
    final asset = pieceSet.assets[piece]!;

    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating =
            context.l10n.puzzleRatingX(puzzle.puzzle.rating.toString());
        final playedXTimes =
            context.l10n.puzzlePlayedXTimes(puzzle.puzzle.plays);
        return _FeedbackTile(
          leading: state.result == PuzzleResult.win
              ? const Icon(Icons.check, size: 36, color: LichessColors.good)
              : null,
          title: onStreak && state.result == PuzzleResult.lose
              ? const Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  state.result == PuzzleResult.win
                      ? context.l10n.puzzlePuzzleSuccess
                      : context.l10n.puzzlePuzzleComplete,
                ),
          subtitle: onStreak && state.result == PuzzleResult.lose
              ? null
              : Text('$puzzleRating. $playedXTimes.'),
        );
      case PuzzleMode.load:
      case PuzzleMode.play:
        if (state.feedback == PuzzleFeedback.bad) {
          return _FeedbackTile(
            leading: const Icon(
              Icons.close,
              size: 36,
              color: LichessColors.error,
            ),
            title: Text(context.l10n.puzzleNotTheMove),
            subtitle: Text(context.l10n.puzzleTrySomethingElse),
          );
        } else if (state.feedback == PuzzleFeedback.good) {
          return _FeedbackTile(
            leading:
                const Icon(Icons.check, size: 36, color: LichessColors.good),
            title: Text(context.l10n.puzzleBestMove),
            subtitle: Text(context.l10n.puzzleKeepGoing),
          );
        } else {
          return _FeedbackTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  asset.assetName,
                  width: 48,
                  height: 48,
                  bundle: asset.bundle,
                  package: asset.package,
                ),
              ),
            ),
            title: Text(context.l10n.yourTurn),
            subtitle: Text(
              state.pov == Side.white
                  ? context.l10n.puzzleFindTheBestMoveForWhite
                  : context.l10n.puzzleFindTheBestMoveForBlack,
            ),
          );
        }
    }
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({
    this.leading,
    required this.title,
    this.subtitle,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = DefaultTextStyle.of(context).style.fontSize;

    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 18),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle.merge(
              style: TextStyle(
                fontSize:
                    defaultFontSize != null ? defaultFontSize * 1.2 : null,
                fontWeight: FontWeight.bold,
              ),
              child: title,
            ),
            if (subtitle != null) subtitle!,
          ],
        ),
      ],
    );
  }
}
