import 'package:auto_size_text/auto_size_text.dart';
import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/study/study_bottom_bar.dart';
import 'package:lichess_mobile/src/view/study/study_gamebook.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/view/study/study_tree_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StudyScreen');

class StudyScreen extends ConsumerWidget {
  const StudyScreen({
    required this.id,
  });

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id));

    return state.when(
      data: (state) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: AutoSizeText(
              state.currentChapterTitle,
              maxLines: 2,
              minFontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              _ChapterButton(id: id),
              _StudyMenu(id: id),
            ],
          ),
          body: _Body(id: id),
        );
      },
      loading: () {
        return const PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text(''),
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, st) {
        _logger.severe('Cannot load study: $error', st);
        return Center(
          child: Text('Cannot load study: $error'),
        );
      },
    );
  }
}

class _StudyMenu extends ConsumerWidget {
  const _StudyMenu({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    return PlatformAppBarMenuButton(
      semanticsLabel: 'Study menu',
      icon: const Icon(Icons.more_horiz),
      actions: [
        AppBarMenuAction(
          icon: Icons.settings,
          label: context.l10n.settingsSettings,
          onPressed: () {
            pushPlatformRoute(
              context,
              screen: StudySettings(id),
            );
          },
        ),
        AppBarMenuAction(
          icon: state.study.liked ? Icons.favorite : Icons.favorite_border,
          label: state.study.liked
              ? context.l10n.studyUnlike
              : context.l10n.studyLike,
          onPressed: () {
            ref.read(studyControllerProvider(id).notifier).toggleLike();
          },
        ),
      ],
    );
  }
}

class _ChapterButton extends ConsumerWidget {
  const _ChapterButton({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).valueOrNull;
    return state == null
        ? const SizedBox.shrink()
        : AppBarIconButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              isDismissible: true,
              builder: (_) => DraggableScrollableSheet(
                initialChildSize: 0.5,
                maxChildSize: 0.95,
                snap: true,
                expand: false,
                builder: (context, scrollController) {
                  return _StudyChaptersMenu(
                    id: id,
                    scrollController: scrollController,
                  );
                },
              ),
            ),
            semanticsLabel:
                context.l10n.studyNbChapters(state.study.chapters.length),
            icon: const Icon(Icons.menu_book),
          );
  }
}

class _StudyChaptersMenu extends ConsumerWidget {
  const _StudyChaptersMenu({
    required this.id,
    required this.scrollController,
  });

  final StudyId id;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    final currentChapterKey = GlobalKey();

    // Scroll to the current chapter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentChapterKey.currentContext != null) {
        Scrollable.ensureVisible(
          currentChapterKey.currentContext!,
          alignment: 0.5,
        );
      }
    });

    return BottomSheetScrollableContainer(
      scrollController: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            context.l10n.studyNbChapters(state.study.chapters.length),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        for (final chapter in state.study.chapters)
          PlatformListTile(
            key: chapter.id == state.currentChapter.id
                ? currentChapterKey
                : null,
            title: Text(chapter.name, maxLines: 2),
            onTap: () {
              ref.read(studyControllerProvider(id).notifier).goToChapter(
                    chapter.id,
                  );
              Navigator.of(context).pop();
            },
            selected: chapter.id == state.currentChapter.id,
          ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.id,
  });

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyState = ref.watch(studyControllerProvider(id)).requireValue;
    final variant = studyState.variant;
    if (!variant.isReadSupported) {
      return DefaultTabController(
        length: 1,
        child: AnalysisLayout(
          boardBuilder: (context, boardSize, borderRadius, orientation) =>
              SizedBox.square(
            dimension: boardSize,
            child: Center(
              child: Text(
                '${variant.label} is not supported yet.',
              ),
            ),
          ),
          children: const [SizedBox.shrink()],
        ),
      );
    }

    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final showEvaluationGauge = analysisPrefs.showEvaluationGauge;
    final numEvalLines = analysisPrefs.numEvalLines;

    final gamebookActive = studyState.gamebookActive;
    final engineGaugeParams = studyState.engineGaugeParams;
    final isComputerAnalysisAllowed = studyState.isComputerAnalysisAllowed;
    final isLocalEvaluationEnabled = studyState.isLocalEvaluationEnabled;
    final currentNode = studyState.currentNode;

    final bottomChild = gamebookActive ? StudyGamebook(id) : StudyTreeView(id);

    return DefaultTabController(
      length: 1,
      child: AnalysisLayout(
        boardBuilder: (context, boardSize, borderRadius, orientation) =>
            _StudyBoard(
          id: id,
          boardSize: boardSize,
          borderRadius: borderRadius,
        ),
        engineGaugeBuilder: isComputerAnalysisAllowed &&
                showEvaluationGauge &&
                engineGaugeParams != null
            ? (context, orientation) {
                return orientation == Orientation.portrait
                    ? EngineGauge(
                        displayMode: EngineGaugeDisplayMode.horizontal,
                        params: engineGaugeParams,
                      )
                    : Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: EngineGauge(
                          displayMode: EngineGaugeDisplayMode.vertical,
                          params: engineGaugeParams,
                        ),
                      );
              }
            : null,
        engineLines: isComputerAnalysisAllowed &&
                isLocalEvaluationEnabled &&
                numEvalLines > 0
            ? EngineLines(
                clientEval: currentNode.eval,
                isGameOver: currentNode.position?.isGameOver ?? false,
                onTapMove: ref
                    .read(
                      studyControllerProvider(id).notifier,
                    )
                    .onUserMove,
              )
            : null,
        bottomBar: StudyBottomBar(id: id),
        children: [bottomChild],
      ),
    );
  }
}

extension on PgnCommentShape {
  Shape get chessground {
    final shapeColor = switch (color) {
      CommentShapeColor.green => ShapeColor.green,
      CommentShapeColor.red => ShapeColor.red,
      CommentShapeColor.blue => ShapeColor.blue,
      CommentShapeColor.yellow => ShapeColor.yellow,
    };
    return from != to
        ? Arrow(
            color: shapeColor.color,
            orig: from,
            dest: to,
          )
        : Circle(color: shapeColor.color, orig: from);
  }
}

class _StudyBoard extends ConsumerStatefulWidget {
  const _StudyBoard({
    required this.id,
    required this.boardSize,
    this.borderRadius,
  });

  final StudyId id;

  final double boardSize;

  final BorderRadiusGeometry? borderRadius;

  @override
  ConsumerState<_StudyBoard> createState() => _StudyBoardState();
}

class _StudyBoardState extends ConsumerState<_StudyBoard> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    // Clear shapes when switching to a new chapter.
    // This avoids "leftover" shapes from the previous chapter when the engine has not evaluated the new position yet.
    ref.listen(
        studyControllerProvider(widget.id).select((state) => state.hasValue),
        (prev, next) {
      if (prev != next) {
        setState(() {
          userShapes = ISet();
        });
      }
    });
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final studyState =
        ref.watch(studyControllerProvider(widget.id)).requireValue;

    final currentNode = studyState.currentNode;
    final position = currentNode.position;

    final showVariationArrows = ref.watch(
          studyPreferencesProvider.select(
            (prefs) => prefs.showVariationArrows,
          ),
        ) &&
        !studyState.gamebookActive &&
        currentNode.children.length > 1;

    final pgnShapes = ISet(
      studyState.pgnShapes.map((shape) => shape.chessground),
    );

    final variationArrows = ISet<Shape>(
      showVariationArrows
          ? currentNode.children.mapIndexed((i, move) {
              final color = Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.5);
              return Arrow(
                color: color,
                orig: (move as NormalMove).from,
                dest: move.to,
              );
            }).toList()
          : [],
    );

    final showAnnotationsOnBoard = ref.watch(
      analysisPreferencesProvider.select((value) => value.showAnnotations),
    );

    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select(
        (value) => value.showBestMoveArrow,
      ),
    );
    final bestMoves = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMoves),
    );
    final ISet<Shape> bestMoveShapes =
        showBestMoveArrow && studyState.isEngineAvailable && bestMoves != null
            ? computeBestMoveShapes(
                bestMoves,
                currentNode.position!.turn,
                boardPrefs.pieceSet.assets,
              )
            : ISet();

    final sanMove = currentNode.sanMove;
    final annotation = makeAnnotation(studyState.currentNode.nags);

    return Chessboard(
      size: widget.boardSize,
      settings: boardPrefs.toBoardSettings().copyWith(
            borderRadius: widget.borderRadius,
            boxShadow: widget.borderRadius != null
                ? boardShadows
                : const <BoxShadow>[],
            drawShape: DrawShapeOptions(
              enable: true,
              onCompleteShape: _onCompleteShape,
              onClearShapes: _onClearShapes,
              newShapeColor: boardPrefs.shapeColor.color,
            ),
          ),
      fen: studyState.position?.board.fen ??
          studyState.study.currentChapterMeta.fen ??
          kInitialFEN,
      lastMove: studyState.lastMove as NormalMove?,
      orientation: studyState.pov,
      shapes: pgnShapes
          .union(userShapes)
          .union(variationArrows)
          .union(bestMoveShapes),
      annotations:
          showAnnotationsOnBoard && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({
                      Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation,
                    })
                  : IMap({sanMove.move.to: annotation})
              : null,
      game: position != null
          ? GameData(
              playerSide: studyState.playerSide,
              isCheck: position.isCheck,
              sideToMove: position.turn,
              validMoves: makeLegalMoves(position),
              promotionMove: studyState.promotionMove,
              onMove: (move, {isDrop, captured}) {
                ref
                    .read(studyControllerProvider(widget.id).notifier)
                    .onUserMove(move);
              },
              onPromotionSelection: (role) {
                ref
                    .read(studyControllerProvider(widget.id).notifier)
                    .onPromotionSelection(role);
              },
            )
          : null,
    );
  }

  void _onCompleteShape(Shape shape) {
    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }
}
