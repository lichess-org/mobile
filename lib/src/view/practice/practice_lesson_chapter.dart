import 'package:chessground/chessground.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/practice/practice_board_layout.dart';
import 'package:lichess_mobile/src/view/practice/practice_chapter_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:material_ui/material_ui.dart';

/// A practice lesson: a commented game to browse.
///
/// There is nothing to solve, so the chapter is done as soon as it is opened.
class const PracticeLessonChapterBody({required final PracticeLessonChapter chapter})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<PracticeLessonChapterBody> createState() => _PracticeLessonChapterBodyState();
}

class _PracticeLessonChapterBodyState() extends ConsumerState<PracticeLessonChapterBody> {
  late final ViewRoot _root;
  late final IList<ViewBranch> _mainline;

  /// How far along the mainline the board is.
  int _ply = 0;

  @override
  void initState() {
    super.initState();
    _root = Root.fromPgnGame(PgnGame.parsePgn(widget.chapter.pgn)).view;
    _mainline = _root.mainline.toIList();
    ref.read(practiceProgressProvider.notifier).complete(widget.chapter.id, 0);
  }

  void _goTo(int ply) => setState(() => _ply = ply.clamp(0, _mainline.length));

  @override
  Widget build(BuildContext context) {
    final node = _ply == 0 ? null : _mainline[_ply - 1];
    final comment = node?.textComments.join('\n');
    final shapes = [...?node?.comments?.expand((comment) => comment.shapes)];

    return PracticeBoardLayout(
      orientation: widget.chapter.orientation,
      position: node?.position ?? _root.position,
      playerSide: PlayerSide.none,
      lastMove: node?.sanMove.move,
      shapes: shapes.map((shape) => shape.chessground).toISet(),
      moves: [for (final branch in _mainline) branch.sanMove.san],
      currentMoveIndex: _ply,
      onSelectMove: _goTo,
      table: PracticeTable(
        children: [
          if (comment != null && comment.isNotEmpty) PracticeText(text: comment),
          if (widget.chapter.description case final description?) PracticeText(text: description),
        ],
      ),
      bottomBar: BottomBar(
        children: [
          BottomBarButton(
            label: context.l10n.studyBack,
            icon: CupertinoIcons.chevron_back,
            onTap: _ply > 0 ? () => _goTo(_ply - 1) : null,
          ),
          BottomBarButton(
            label: context.l10n.studyNext,
            icon: CupertinoIcons.chevron_forward,
            onTap: _ply < _mainline.length ? () => _goTo(_ply + 1) : null,
          ),
          BottomBarButton(
            label: context.l10n.studyNextChapter,
            icon: Icons.skip_next,
            showLabel: true,
            onTap: () => goToNextPracticeChapter(context, ref, widget.chapter),
          ),
        ],
      ),
    );
  }
}
