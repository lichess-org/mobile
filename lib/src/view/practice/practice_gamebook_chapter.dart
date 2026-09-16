import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/practice/practice_gamebook_controller.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/practice/practice_board_layout.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';

/// A practice gamebook chapter: authored moves to find, one at a time.
class const PracticeGamebookChapterBody({required final PracticeGamebookChapter chapter})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = practiceGamebookControllerProvider(chapter);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final playerSide = chapter.orientation == Side.white ? PlayerSide.white : PlayerSide.black;
    final solution = state.solution;

    return PracticeBoardLayout(
      orientation: chapter.orientation,
      position: state.position,
      playerSide: state.feedback == .play ? playerSide : PlayerSide.none,
      lastMove: state.lastMove,
      onMove: controller.onUserMove,
      shapes: {
        ...state.shapes.map((shape) => shape.chessground),
        if (solution case NormalMove(:final from, :final to))
          Arrow(color: ShapeColor.green.color, orig: from, dest: to),
      }.lock,
      table: _Table(state: state),
      bottomBar: BottomBar(
        children: [
          BottomBarButton(
            label: context.l10n.studyPlayAgain,
            icon: Icons.restart_alt,
            onTap: state.ply > 0 || state.wrongMove != null ? controller.restart : null,
          ),
          switch (state.feedback) {
            .play => BottomBarButton(
              label: context.l10n.viewTheSolution,
              icon: Icons.flag_outlined,
              highlighted: state.isSolutionShown,
              onTap: controller.toggleSolution,
            ),
            .good => BottomBarButton(
              label: context.l10n.studyNext,
              icon: Icons.chevron_right,
              showLabel: true,
              onTap: controller.next,
            ),
            .bad => BottomBarButton(
              label: context.l10n.retry,
              icon: Icons.refresh,
              showLabel: true,
              onTap: controller.retry,
            ),
            .end => BottomBarButton(
              label: context.l10n.studyNextChapter,
              icon: Icons.chevron_right,
              showLabel: true,
              onTap: () => goToNextPracticeChapter(context, ref, chapter),
            ),
          },
        ],
      ),
    );
  }
}

/// The author's comment, the hint, and the chapter's description.
class const _Table({required final PracticeGamebookState state}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(practiceGamebookControllerProvider(state.chapter).notifier);
    final hint = state.hint;
    final result = switch (state.feedback) {
      .play => null,
      .good => (Icons.check_circle, LichessColors.good, context.l10n.studyGoodMove),
      .bad => (Icons.cancel, LichessColors.error, context.l10n.puzzleNotTheMove),
      .end => (Icons.check_circle, LichessColors.good, context.l10n.studyYouCompletedThisLesson),
    };
    final comment =
        state.comment ?? (state.feedback == .play ? context.l10n.studyWhatWouldYouPlay : null);

    return PracticeTable(
      children: [
        if (result case (final icon, final color, final label))
          PracticeFeedbackLine(icon: icon, color: color, text: label),
        if (comment != null) PracticeText(text: comment),
        if (hint != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: state.isHintShown
                ? PracticeText(
                    text: hint,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  )
                : TextButton.icon(
                    onPressed: controller.toggleHint,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: Text(context.l10n.getAHint),
                  ),
          ),
        if (state.chapter.description case final description? when state.ply == 0)
          PracticeText(text: description),
      ],
    );
  }
}
