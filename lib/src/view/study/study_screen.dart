import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_player_widget.dart';
import 'package:lichess_mobile/src/view/analysis/server_analysis.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/explorer/explorer_view.dart';
import 'package:lichess_mobile/src/view/study/study_bottom_bar.dart';
import 'package:lichess_mobile/src/view/study/study_gamebook.dart';
import 'package:lichess_mobile/src/view/study/study_tree_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

final _logger = Logger('StudyScreen');

class StudyScreen extends StatelessWidget {
  const StudyScreen({required this.options, super.key});

  final StudyOptions options;

  static Route<dynamic> buildRoute(StudyOptions options) {
    return buildScreenRoute(screen: StudyScreen(options: options));
  }

  @override
  Widget build(BuildContext context) {
    return _StudyScreenLoader(options: options);
  }
}

class _StudyScreenLoader extends ConsumerWidget {
  const _StudyScreenLoader({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final studyPrefs = ref.watch(studyPreferencesProvider);
    switch (ref.watch(studyControllerProvider(options))) {
      case AsyncData(:final value):
        return _StudyScreen(options: options, studyState: value);
      case AsyncError(:final error, :final stackTrace):
        _logger.severe('Cannot load study:', error, stackTrace);
        return Scaffold(
          appBar: AppBar(title: const Text('')),
          body: DefaultTabController(
            length: 1,
            child: AnalysisLayout(
              pov: Side.white,
              sideToMove: null,
              boardBuilder: (context, boardSize, borderRadius) => StaticChessboard(
                size: boardSize,
                settings: StaticChessboardSettings.fromBoardSettings(
                  boardPrefs
                      .toBoardSettings(Variant.standard)
                      .copyWith(
                        borderRadius: borderRadius,
                        boxShadow: borderRadius != null ? boardShadows : const <BoxShadow>[],
                      ),
                ),
                orientation: Side.white,
                fen: kEmptyFEN,
              ),
              smallBoard: studyPrefs.smallBoard,
              children: const [Center(child: Text('Failed to load study.'))],
            ),
          ),
        );
      case _:
        return Scaffold(
          appBar: AppBar(
            title: Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: SizedBox(
                  height: 24.0,
                  width: 200.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: DefaultTabController(
            length: 1,
            child: AnalysisLayout(
              pov: Side.white,
              sideToMove: null,
              boardBuilder: (context, boardSize, borderRadius) => StaticChessboard(
                size: boardSize,
                settings: StaticChessboardSettings.fromBoardSettings(
                  boardPrefs
                      .toBoardSettings(Variant.standard)
                      .copyWith(
                        borderRadius: borderRadius,
                        boxShadow: borderRadius != null ? boardShadows : const <BoxShadow>[],
                      ),
                ),
                orientation: Side.white,
                fen: kEmptyFEN,
              ),
              smallBoard: studyPrefs.smallBoard,
              children: const [Center(child: CircularProgressIndicator.adaptive())],
            ),
          ),
        );
    }
  }
}

class _StudyScreen extends ConsumerStatefulWidget {
  const _StudyScreen({required this.options, required this.studyState});

  final StudyOptions options;
  final StudyState studyState;

  @override
  ConsumerState<_StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<_StudyScreen> with TickerProviderStateMixin {
  late List<AnalysisTab> tabs;
  late TabController _tabController;

  void _initTabs() {
    tabs = [
      if (widget.studyState.isOpeningExplorerAvailable) AnalysisTab.explorer,
      AnalysisTab.moves,
      if (widget.studyState.isServerAnalysisAllowed) AnalysisTab.summary,
    ];

    _tabController = TabController(
      vsync: this,
      initialIndex: tabs.indexOf(AnalysisTab.moves),
      length: tabs.length,
    );
  }

  @override
  void initState() {
    super.initState();

    _initTabs();
  }

  @override
  void didUpdateWidget(covariant _StudyScreen oldWidget) {
    if (oldWidget.studyState.currentChapter.id != widget.studyState.currentChapter.id) {
      _tabController.dispose();
      _initTabs();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.studyState.variant;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (variant != Variant.standard && variant != Variant.fromPosition) ...[
              Icon(variant.icon),
              const SizedBox(width: 5.0),
            ],
            Flexible(child: AppBarTitleText(widget.studyState.currentChapterTitle)),
          ],
        ),
        actions: [_StudyMenu(options: widget.options)],
      ),
      body: _Body(options: widget.options, tabController: _tabController, tabs: tabs),
    );
  }
}

class _StudyMenu extends ConsumerWidget {
  const _StudyMenu({required this.options});

  final StudyOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider);
    final state = ref.watch(studyControllerProvider(options)).requireValue;

    return ContextMenuIconButton(
      semanticsLabel: 'Study menu',
      icon: const Icon(Icons.more_horiz),
      actions: [
        if (authUser != null)
          ContextMenuAction(
            icon: state.study.liked ? Icons.favorite : Icons.favorite_border,
            label: state.study.liked ? 'Stop liking' : context.l10n.studyLike,
            onPressed: () {
              ref.read(studyControllerProvider(options).notifier).toggleLike();
            },
          ),
        ContextMenuAction(
          icon: Theme.of(context).platform == TargetPlatform.iOS ? Icons.ios_share : Icons.share,
          label: context.l10n.studyShareAndExport,
          onPressed: () {
            showAdaptiveActionSheet<void>(
              context: context,
              actions: [
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyStudyUrl),
                  onPressed: () {
                    launchShareDialog(
                      context,
                      ShareParams(uri: lichessUri('/study/${state.study.id}')),
                    );
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyCurrentChapterUrl),
                  onPressed: () {
                    launchShareDialog(
                      context,
                      ShareParams(
                        uri: lichessUri('/study/${state.study.id}/${state.study.chapter.id}'),
                      ),
                    );
                  },
                ),
                if (!state.gamebookActive) ...[
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.studyStudyPgn),
                    onPressed: () async {
                      try {
                        final pgn = await ref
                            .read(studyRepositoryProvider)
                            .getStudyPgn(state.study.id);
                        if (context.mounted) {
                          launchShareDialog(context, ShareParams(text: pgn));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
                        }
                      }
                    },
                  ),
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.studyChapterPgn),
                    onPressed: () {
                      launchShareDialog(context, ShareParams(text: state.pgn));
                    },
                  ),
                  if (state.currentPosition != null)
                    BottomSheetAction(
                      makeLabel: (context) => Text(context.l10n.screenshotCurrentPosition),
                      onPressed: () async {
                        try {
                          final image = await ref
                              .read(gameShareServiceProvider)
                              .screenshotPosition(
                                state.pov,
                                state.currentPosition!.fen,
                                state.lastMove,
                              );
                          if (context.mounted) {
                            launchShareDialog(
                              context,
                              ShareParams(
                                files: [image],
                                subject: context.l10n.puzzleFromGameLink(
                                  lichessUri('/study/${state.study.id}').toString(),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
                          }
                        }
                      },
                    ),
                  BottomSheetAction(
                    makeLabel: (context) => const Text('GIF'),
                    onPressed: () async {
                      try {
                        final gif = await ref
                            .read(gameShareServiceProvider)
                            .chapterGif(state.study.id, state.study.chapter.id);
                        if (context.mounted) {
                          launchShareDialog(
                            context,
                            ShareParams(
                              files: [gif],
                              subject: context.l10n.studyChapterX(
                                state.study.currentChapterMeta.name,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        if (context.mounted) {
                          showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
                        }
                      }
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CannotRequestServerAnalysisReason extends StatelessWidget {
  const _CannotRequestServerAnalysisReason({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text(reason)),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.options, required this.tabController, required this.tabs});

  final StudyOptions options;
  final TabController tabController;
  final List<AnalysisTab> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyState = ref.watch(studyControllerProvider(options)).requireValue;
    final studyPrefs = ref.watch(studyPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final variant = studyState.variant;
    if (!variant.isReadSupported) {
      return DefaultTabController(
        length: 1,
        child: AnalysisLayout(
          pov: Side.white,
          sideToMove: null,
          boardBuilder: (context, boardSize, borderRadius) => SizedBox.square(
            dimension: boardSize,
            child: Center(
              child: Text(context.l10n.mobileUnsupportedVariant(variant.label(context.l10n))),
            ),
          ),
          smallBoard: studyPrefs.smallBoard,
          children: const [SizedBox.shrink()],
        ),
      );
    }

    final showEvaluationGauge = studyPrefs.showEvaluationGauge;
    final numEvalLines = enginePrefs.numEvalLines;

    final gamebookActive = studyState.gamebookActive;
    final engineGaugeParams = studyState.engineGaugeParams(enginePrefs);
    final isComputerAnalysisAllowed = studyState.isComputerAnalysisAllowed;
    final isLocalEvaluationEnabled = studyState.isEngineAvailable(enginePrefs);
    final pov = studyState.pov;

    final bottomChild = gamebookActive
        ? StudyGamebook(options)
        : StudyTreeView(options, showTopDivider: tabs.length == 1);

    final playerWidgets = playerWidgetsFromPgnHeaders(
      pgnHeaders: studyState.pgnHeaders,
      sideToMove: studyState.currentPosition?.turn ?? Side.white,
      whiteClock: studyState.currentPosition?.turn == Side.white
          ? studyState.clocks?.parentClock
          : studyState.clocks?.clock,
      blackClock: studyState.currentPosition?.turn == Side.black
          ? studyState.clocks?.parentClock
          : studyState.clocks?.clock,
    );

    return AnalysisLayout(
      tabController: tabController,
      pov: pov,
      sideToMove: studyState.currentPosition?.turn,
      boardBuilder: (context, boardSize, borderRadius) =>
          StudyAnalysisBoard(options: options, boardSize: boardSize, boardRadius: borderRadius),
      smallBoard: studyPrefs.smallBoard,
      boardHeader: pov == Side.white ? playerWidgets.black : playerWidgets.white,
      boardFooter: pov == Side.white ? playerWidgets.white : playerWidgets.black,
      engineGaugeBuilder:
          isComputerAnalysisAllowed && showEvaluationGauge && engineGaugeParams != null
          ? (context) {
              return EngineGauge(params: engineGaugeParams);
            }
          : null,
      engineLines:
          isComputerAnalysisAllowed &&
              studyPrefs.showEngineLines &&
              isLocalEvaluationEnabled &&
              numEvalLines > 0
          ? EngineLines(
              filters: (context: studyState.evaluationContext, path: studyState.currentPath),
              analysisState: studyState,
              onTapMove: ref.read(studyControllerProvider(options).notifier).onUserMove,
            )
          : null,
      bottomBar: StudyBottomBar(options: options),
      pockets: studyState.currentPosition?.pockets,
      tabs: tabs,
      children: tabs.map((tab) {
        switch (tab) {
          case AnalysisTab.explorer:
            if (studyState.isOpeningExplorerAvailable && studyState.currentNode.position != null) {
              return ExplorerView(
                pov: pov,
                position: studyState.currentNode.position!,
                opening: explorerOpening(
                  context,
                  variant: studyState.variant,
                  isRootNode: studyState.currentNode.isRoot,
                  nodeOpening: studyState.currentNode.opening,
                  branchOpening: studyState.currentBranchOpening,
                ),
                onMoveSelected: (move) {
                  ref.read(studyControllerProvider(options).notifier).onUserMove(move);
                },
                isComputerAnalysisAllowed: true,
              );
            } else {
              return const Center(child: Text('Opening explorer not available.'));
            }
          case AnalysisTab.summary:
            switch (studyState.chapterServerAnalysisStatus) {
              case ChapterServerAnalysisStatus.canRequest || ChapterServerAnalysisStatus.available:
                return ServerAnalysisSummary(
                  serverAnalysisSource: studyState.serverAnalysisSource,
                  playersAnalysis: studyState.playersAnalysis,
                  pgnHeaders: studyState.pgnHeaders,
                  acplChartParams: studyState.acplChartData != null
                      ? (
                          acplChartData: studyState.acplChartData!,
                          division: studyState.analysisSummary?.division,
                          rootPly: studyState.root!.position.ply,
                          currentNodePly: studyState.currentPosition!.ply,
                          isOnMainline: studyState.isOnMainline,
                          onJumpToNode: ref
                              .read(studyControllerProvider(options).notifier)
                              .jumpToNthNodeOnMainline,
                        )
                      : null,
                  onRequestServerAnalysis: ref
                      .read(studyControllerProvider(options).notifier)
                      .requestServerAnalysis,
                );
              case ChapterServerAnalysisStatus.notEnoughMoves:
                return _CannotRequestServerAnalysisReason(
                  reason: context.l10n.studyTheChapterIsTooShortToBeAnalysed,
                );
              case ChapterServerAnalysisStatus.notWriteable:
                return _CannotRequestServerAnalysisReason(
                  reason: context.l10n.studyOnlyContributorsCanRequestAnalysis,
                );
            }
          case _:
            return bottomChild;
        }
      }).toList(),
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
        ? Arrow(color: shapeColor.color, orig: from, dest: to)
        : Circle(color: shapeColor.color, orig: from);
  }
}

class StudyAnalysisBoard extends AnalysisBoard {
  const StudyAnalysisBoard({required this.options, required super.boardSize, super.boardRadius});

  final StudyOptions options;

  @override
  ConsumerState<StudyAnalysisBoard> createState() => _StudyAnalysisBoardState();
}

class _StudyAnalysisBoardState
    extends AnalysisBoardState<StudyAnalysisBoard, StudyState, StudyPrefs> {
  @override
  StudyState? readCurrentState() => ref.read(studyControllerProvider(widget.options)).value;

  @override
  void listenToStateChanges(void Function(StudyState? prev, StudyState? next) listener) =>
      ref.listenManual<StudyState?>(
        studyControllerProvider(widget.options).select((v) => v.value),
        listener,
      );

  @override
  StudyState get analysisState => ref.watch(studyControllerProvider(widget.options)).requireValue;

  @override
  bool computeInteractive(StudyState state) =>
      !state.gamebookActive || state.currentPosition?.turn == state.pov;

  @override
  StudyPrefs get analysisPrefs => ref.watch(studyPreferencesProvider);

  @override
  bool get showAnnotations => analysisPrefs.showAnnotations;

  @override
  void onUserMove(Move move) {
    ref.read(studyControllerProvider(widget.options).notifier).onUserMove(move);
  }

  @override
  EngineEvaluationFilters get engineEvaluationFilters =>
      (context: analysisState.evaluationContext, path: analysisState.currentPath);

  @override
  String computeFen(StudyState state) =>
      state.currentPosition?.board.fen ?? state.study.currentChapterMeta.fen ?? kInitialFEN;

  @override
  ISet<Shape> get extraShapes {
    final showVariationArrows =
        ref.watch(studyPreferencesProvider.select((prefs) => prefs.showVariationArrows)) &&
        !analysisState.gamebookActive &&
        analysisState.currentNode.children.length > 1;

    final pgnShapes = ISet(analysisState.pgnShapes.map((shape) => shape.chessground));
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final variationArrows = ISet<Shape>(
      showVariationArrows
          ? analysisState.currentNode.children
                .mapIndexed(
                  (i, move) => moveShapes(
                    move: move,
                    color: Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.5),
                    sideToMove: analysisState.currentPosition!.turn,
                    pieceAssets: boardPrefs.pieceSet.assets,
                  ),
                )
                .flattened
                .toList()
          : [],
    );

    return pgnShapes.union(variationArrows);
  }

  @override
  Widget build(BuildContext context) {
    // Clear shapes when switching to a new chapter.
    // This avoids "leftover" shapes from the previous chapter when the engine has not evaluated the new position yet.
    ref.listen(studyControllerProvider(widget.options).select((state) => state.hasValue), (
      prev,
      next,
    ) {
      if (prev != next) {
        clearDrawnShapes();
      }
    });

    return super.build(context);
  }
}
