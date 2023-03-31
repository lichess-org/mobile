import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import 'puzzle_view_model.dart';

class PuzzleFeedbackWidget extends StatelessWidget {
  const PuzzleFeedbackWidget({
    required this.puzzle,
    required this.state,
    required this.pieceSet,
    required this.onStreak,
  });

  final Puzzle puzzle;
  final PuzzleViewModelState state;
  final cg.PieceSet pieceSet;
  final bool onStreak;

  @override
  Widget build(BuildContext context) {
    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating =
            context.l10n.puzzleRatingX(puzzle.puzzle.rating.toString());
        final playedXTimes =
            context.l10n.puzzlePlayedXTimes(puzzle.puzzle.plays);
        return PlatformCard(
          child: ListTile(
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
          ),
        );
      case PuzzleMode.play:
        if (state.feedback == PuzzleFeedback.bad) {
          return PlatformCard(
            child: ListTile(
              leading: const Icon(
                Icons.close,
                size: 36,
                color: LichessColors.error,
              ),
              title: Text(context.l10n.puzzleNotTheMove),
              subtitle: Text(context.l10n.puzzleTrySomethingElse),
            ),
          );
        } else if (state.feedback == PuzzleFeedback.good) {
          return PlatformCard(
            child: ListTile(
              leading:
                  const Icon(Icons.check, size: 36, color: LichessColors.good),
              title: Text(context.l10n.puzzleBestMove),
              subtitle: Text(context.l10n.puzzleKeepGoing),
            ),
          );
        } else {
          return PlatformCard(
            child: ListTile(
              leading: Image(
                image: pieceSet.assets[state.pov == Side.white
                    ? cg.PieceKind.whiteKing
                    : cg.PieceKind.blackKing]!,
                height: 56,
              ),
              title: Text(context.l10n.yourTurn),
              subtitle: Text(
                state.pov == Side.white
                    ? context.l10n.puzzleFindTheBestMoveForWhite
                    : context.l10n.puzzleFindTheBestMoveForBlack,
              ),
            ),
          );
        }
    }
  }
}
