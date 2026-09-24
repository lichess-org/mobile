import 'package:chessground/chessground.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/practice/practice_engine_controller.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/practice/practice_board_layout.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';

/// A practice chapter played against the engine.
class const PracticeEngineChapterBody({required final PracticeEngineChapter chapter})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = practiceEngineControllerProvider(chapter);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final playerSide = chapter.orientation == Side.white ? PlayerSide.white : PlayerSide.black;

    return FocusDetector(
      onFocusLost: controller.suspendAnalysis,
      onFocusRegained: controller.resumeAnalysis,
      child: PracticeBoardLayout(
        orientation: chapter.orientation,
        position: state.position,
        playerSide: state.canPlay ? playerSide : PlayerSide.none,
        lastMove: state.steps.lastOrNull?.sanMove.move,
        onMove: controller.onUserMove,
        shapes: _shapes(state),
        isBusy: state.isEngineThinking,
        moves: [for (final step in state.steps) step.sanMove.san],
        table: _Table(state: state),
        bottomBar: BottomBar(
          children: [
            BottomBarButton(
              label: context.l10n.getAHint,
              icon: CupertinoIcons.lightbulb,
              highlighted: state.hint != null,
              onTap: state.canPlay && state.eval != null ? controller.hint : null,
            ),
            BottomBarButton(
              label: context.l10n.retry,
              icon: Icons.refresh,
              onTap: state.steps.isNotEmpty || state.status != .ongoing ? controller.retry : null,
            ),
            BottomBarButton(
              label: context.l10n.analysis,
              icon: Icons.biotech,
              onTap: () => Navigator.of(context).push(
                AnalysisScreen.buildRoute(
                  AnalysisOptions.pgn(
                    id: StringId('practice-${chapter.id}'),
                    orientation: chapter.orientation,
                    pgn: _pgn(state),
                    isComputerAnalysisAllowed: true,
                    variant: Variant.standard,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ISet<Shape> _shapes(PracticeEngineState state) {
    final hint = switch (state.hint) {
      PracticeHintPiece(:final square) => Circle(color: ShapeColor.green.color, orig: square),
      PracticeHintMove(:final move) => Arrow(
        color: ShapeColor.green.color,
        orig: move.from,
        dest: move.to,
      ),
      null => null,
    };
    // Once the chapter is failed, the move that should have been played.
    final best = state.status == .failed ? state.feedback?.bestMove?.move : null;
    return {
      ?hint,
      if (best case NormalMove(:final from, :final to))
        Arrow(color: ShapeColor.blue.color, orig: from, dest: to),
    }.lock;
  }

  /// The moves played, from the chapter's position, for the analysis board.
  String _pgn(PracticeEngineState state) {
    final root = Root(position: state.initialPosition);
    root.addMovesAt(UciPath.empty, state.steps.map((step) => step.sanMove.move));
    return root.makePgn({'FEN': chapter.fen, 'SetUp': '1'}.lock);
  }
}

/// The goal, the verdict on the last move, and the result.
class const _Table({required final PracticeEngineState state}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = state.chapter;
    final goal = chapter.goal;
    final feedback = state.feedback;

    return PracticeTable(
      children: [
        switch (state.status) {
          .solved => const PracticeFeedbackLine(
            icon: Icons.check_circle,
            color: LichessColors.good,
            text: 'Success!',
          ),
          .failed => PracticeFeedbackLine(
            icon: Icons.cancel,
            color: LichessColors.error,
            text: goal.describe(playerSide: chapter.orientation, movesLeft: goal.movesAllowed ?? 0),
          ),
          .ongoing => Text(
            goal.describe(
              playerSide: chapter.orientation,
              movesLeft: (goal.movesAllowed ?? 0) - state.nbMoves,
            ),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        },
        if (feedback != null)
          PracticeFeedbackLine(
            icon: feedback.verdict.icon,
            color: feedback.verdict.color,
            text: feedback.verdict.label(context),
            trailing: switch (feedback.bestMove) {
              final best? => Text(context.l10n.bestWasX(best.san)),
              null => null,
            },
          ),
        switch (state.status) {
          .solved => Align(child: PracticeNextChapterButton(chapter: chapter)),
          .failed => Align(
            child: FilledButton.icon(
              onPressed: ref.read(practiceEngineControllerProvider(chapter).notifier).retry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ),
          .ongoing => const SizedBox.shrink(),
        },
        if (chapter.description case final description?) PracticeText(text: description),
      ],
    );
  }
}

extension on MoveVerdict {
  IconData get icon => switch (this) {
    .goodMove => Icons.check_circle,
    .notBest => Icons.info,
    .inaccuracy => Icons.help,
    .mistake => Icons.error,
    .blunder => Icons.cancel,
  };

  Color get color => switch (this) {
    .goodMove || .notBest => LichessColors.good,
    .inaccuracy => LichessColors.inaccuracy,
    .mistake => LichessColors.mistake,
    .blunder => LichessColors.blunder,
  };

  String label(BuildContext context) => switch (this) {
    .goodMove => context.l10n.studyGoodMove,
    .notBest => context.l10n.mobileGoodMoveButThereIsBetter,
    .inaccuracy => context.l10n.inaccuracy,
    .mistake => context.l10n.mistake,
    .blunder => context.l10n.blunder,
  };
}
