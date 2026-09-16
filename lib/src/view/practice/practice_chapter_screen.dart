import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/practice/practice_engine_chapter.dart';
import 'package:lichess_mobile/src/view/practice/practice_gamebook_chapter.dart';
import 'package:lichess_mobile/src/view/practice/practice_lesson_chapter.dart';
import 'package:lichess_mobile/src/view/practice/practice_study_icon.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/rich_link_text.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// A practice chapter, played the way its kind is played.
class const PracticeChapterScreen({required final PracticeChapter chapter, super.key})
    extends ConsumerWidget {
  static Route<dynamic> buildRoute(PracticeChapter chapter) {
    return buildScreenRoute(screen: PracticeChapterScreen(chapter: chapter));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Chapters',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              // Sized to its content, up to most of the screen: a long study scrolls, and the
              // barrier left above it and the handle still close it.
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              constraints: BoxConstraints(maxHeight: MediaQuery.heightOf(context) * 0.9),
              builder: (_) => _ChaptersSheet(current: chapter),
            ),
          ),
          const ToggleSoundButton(),
        ],
      ),
      body: switch (chapter) {
        final PracticeEngineChapter chapter => PracticeEngineChapterBody(chapter: chapter),
        final PracticeGamebookChapter chapter => PracticeGamebookChapterBody(chapter: chapter),
        final PracticeLessonChapter chapter => PracticeLessonChapterBody(chapter: chapter),
      },
    );
  }
}

/// The chapters of the current chapter's study, to jump to any of them.
class const _ChaptersSheet({required final PracticeChapter current}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final study = ref.watch(practiceStructureProvider).value?.studyOf(current.id);
    final progress = ref.watch(practiceProgressProvider).value ?? PracticeProgress.empty;
    if (study == null) return const SizedBox.shrink();

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.only(bottom: 16.0),
      children: [
        ListTile(
          leading: PracticeStudyIcon(study: study, size: 40.0),
          title: Text(study.name, style: Styles.title),
        ),
        for (final chapter in study.chapters)
          ListTile(
            selected: chapter.id == current.id,
            leading: Icon(switch (chapter) {
              PracticeEngineChapter() => Icons.memory,
              PracticeGamebookChapter() => Icons.menu_book,
              PracticeLessonChapter() => Icons.play_lesson,
            }),
            title: Text(chapter.name),
            subtitle: Text(practiceChapterKindLabel(context, chapter)),
            trailing: progress.isDone(chapter.id)
                ? const Icon(Icons.check_circle, color: LichessColors.good)
                : null,
            onTap: () {
              Navigator.of(context).pop();
              if (chapter.id != current.id) {
                // Replaced rather than pushed, so that going back always leads to the practice
                // menu.
                Navigator.of(context).pushReplacement(PracticeChapterScreen.buildRoute(chapter));
              }
            },
          ),
      ],
    );
  }
}

/// Opens the chapter after [chapter] in its study, or goes back to the practice menu when it was
/// the last.
void goToNextPracticeChapter(BuildContext context, WidgetRef ref, PracticeChapter chapter) {
  final next = ref.read(practiceStructureProvider).value?.nextChapter(chapter.id);
  if (next != null) {
    Navigator.of(context).pushReplacement(PracticeChapterScreen.buildRoute(next));
  } else {
    Navigator.of(context).pop();
  }
}

/// The button that moves on once a chapter is done.
class const PracticeNextChapterButton({required final PracticeChapter chapter})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNext = ref.watch(
      practiceStructureProvider.select((s) => s.value?.nextChapter(chapter.id) != null),
    );
    return FilledButton.icon(
      onPressed: () => goToNextPracticeChapter(context, ref, chapter),
      icon: Icon(hasNext ? Icons.chevron_right : Icons.chevron_left),
      iconAlignment: hasNext ? IconAlignment.end : IconAlignment.start,
      label: Text(hasNext ? 'Next exercise' : 'Back to practice'),
    );
  }
}

/// Text written by a study author, with its links opened in the browser.
class const PracticeText({required final String text, final TextStyle? style})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichLinkText(
      text: text,
      style: style ?? const TextStyle(fontSize: 16.0),
      onOpen: (link) => launchUrl(Uri.parse(link.url)),
    );
  }
}

/// The area under the board: whatever the chapter has to say, scrollable.
class const PracticeTable({required final List<Widget> children}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Styles.bodyPadding,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: 12.0),
          child,
        ],
      ],
    );
  }
}

/// A result or verdict line, in its color.
class const PracticeFeedbackLine({
  required final IconData icon,
  required final Color color,
  required final String text,
  final Widget? trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(text, style: Styles.callout.copyWith(color: color)),
        ),
        ?trailing,
      ],
    );
  }
}

extension PracticeGoalText on PracticeGoal {
  /// What the player has to do, with [movesLeft] moves left to do it in.
  ///
  /// The wording of lichess.org, which is not translated there either.
  String describe({required Side playerSide, required int movesLeft}) {
    String moves(int count, [String what = 'move']) => '$count $what${count == 1 ? '' : 's'}';
    return switch (this) {
      PracticeGoalMate() => 'Checkmate the opponent',
      PracticeGoalMateIn() => 'Checkmate the opponent in ${moves(movesLeft)}',
      PracticeGoalDrawIn() => 'Hold the draw for ${moves(movesLeft, 'more move')}',
      PracticeGoalEqualIn() => 'Equalize in ${moves(movesLeft)}',
      PracticeGoalEvalIn(:final cp) =>
        (playerSide == Side.white) == (cp >= 0)
            ? 'Get a winning position in ${moves(movesLeft)}'
            : 'Defend for ${moves(movesLeft)}',
      PracticeGoalPromotion() => 'Safely promote your pawn',
    };
  }

  /// The number of moves the goal allows, if it counts them.
  int? get movesAllowed => switch (this) {
    PracticeGoalMateIn(:final moves) ||
    PracticeGoalDrawIn(:final moves) ||
    PracticeGoalEqualIn(:final moves) ||
    PracticeGoalEvalIn(:final moves) => moves,
    PracticeGoalMate() || PracticeGoalPromotion() => null,
  };
}

extension PracticePgnShape on PgnCommentShape {
  /// The shape as the board draws it.
  Shape get chessground {
    final color = switch (this.color) {
      CommentShapeColor.green => ShapeColor.green,
      CommentShapeColor.red => ShapeColor.red,
      CommentShapeColor.blue => ShapeColor.blue,
      CommentShapeColor.yellow => ShapeColor.yellow,
    }.color;
    return from != to
        ? Arrow(color: color, orig: from, dest: to)
        : Circle(color: color, orig: from);
  }
}

/// The label of a practice chapter's kind, for the list of chapters.
String practiceChapterKindLabel(BuildContext context, PracticeChapter chapter) => switch (chapter) {
  PracticeEngineChapter(:final goal, :final orientation) => goal.describe(
    playerSide: orientation,
    movesLeft: goal.movesAllowed ?? 0,
  ),
  PracticeGamebookChapter() => context.l10n.studyInteractiveLesson,
  PracticeLessonChapter() => 'Lesson',
};
