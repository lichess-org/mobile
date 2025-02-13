import 'package:auto_size_text/auto_size_text.dart';
import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/view/study/study_bottom_bar.dart';
import 'package:lichess_mobile/src/view/study/study_gamebook.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/view/study/study_tree_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/interactive_board.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StudyScreen');

class StudyScreen extends StatelessWidget {
  const StudyScreen({required this.id, super.key});

  final StudyId id;

  static Route<dynamic> buildRoute(BuildContext context, StudyId id) {
    return buildScreenRoute(context, screen: StudyScreen(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return _StudyScreenLoader(id: id);
  }
}

class _StudyScreenLoader extends ConsumerWidget {
  const _StudyScreenLoader({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    switch (ref.watch(studyControllerProvider(id))) {
      case AsyncData(:final value):
        return _StudyScreen(id: id, studyState: value);
      case AsyncError(:final error, :final stackTrace):
        _logger.severe('Cannot load study: $error', stackTrace);
        return PlatformScaffold(
          enableBackgroundFilterBlur: false,
          appBarTitle: const Text(''),
          body: DefaultTabController(
            length: 1,
            child: AnalysisLayout(
              boardBuilder:
                  (context, boardSize, borderRadius) => Chessboard.fixed(
                    size: boardSize,
                    settings: boardPrefs.toBoardSettings().copyWith(
                      borderRadius: borderRadius,
                      boxShadow: borderRadius != null ? boardShadows : const <BoxShadow>[],
                    ),
                    orientation: Side.white,
                    fen: kEmptyFEN,
                  ),
              children: const [Center(child: Text('Failed to load study.'))],
            ),
          ),
        );
      case _:
        return PlatformScaffold(
          enableBackgroundFilterBlur: false,
          appBarTitle: Shimmer(
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
          body: DefaultTabController(
            length: 1,
            child: AnalysisLayout(
              boardBuilder:
                  (context, boardSize, borderRadius) => Chessboard.fixed(
                    size: boardSize,
                    settings: boardPrefs.toBoardSettings().copyWith(
                      borderRadius: borderRadius,
                      boxShadow: borderRadius != null ? boardShadows : const <BoxShadow>[],
                    ),
                    orientation: Side.white,
                    fen: kEmptyFEN,
                  ),
              children: const [Center(child: CircularProgressIndicator.adaptive())],
            ),
          ),
        );
    }
  }
}

class _StudyScreen extends ConsumerStatefulWidget {
  const _StudyScreen({required this.id, required this.studyState});

  final StudyId id;
  final StudyState studyState;

  @override
  ConsumerState<_StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<_StudyScreen> with TickerProviderStateMixin {
  late List<AnalysisTab> tabs;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    tabs = [
      if (widget.studyState.isOpeningExplorerAvailable) AnalysisTab.opening,
      AnalysisTab.moves,
    ];

    _tabController = TabController(vsync: this, initialIndex: tabs.length - 1, length: tabs.length);
  }

  @override
  void didUpdateWidget(covariant _StudyScreen oldWidget) {
    // If the study has not yet loaded the opening explorer and it is now available
    // with this chapter, add the opening tab.
    // We don't want to remove a tab, so if the opening explorer is not available
    // anymore, we keep the tabs as they are.
    // In theory, studies mixing chapters with and without opening explorer should be pretty rare.
    if (tabs.length < 2 && widget.studyState.isOpeningExplorerAvailable) {
      tabs = [AnalysisTab.opening, AnalysisTab.moves];
      _tabController = TabController(
        vsync: this,
        initialIndex: tabs.length - 1,
        length: tabs.length,
      );
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
    return PlatformScaffold(
      enableBackgroundFilterBlur: false,
      appBarTitle: AutoSizeText(
        widget.studyState.currentChapterTitle,
        maxLines: 2,
        minFontSize: 14,
        overflow: TextOverflow.ellipsis,
      ),
      appBarActions: [
        if (tabs.length > 1) AppBarAnalysisTabIndicator(tabs: tabs, controller: _tabController),
        _StudyMenu(id: widget.id),
      ],
      body: _Body(id: widget.id, tabController: _tabController, tabs: tabs),
    );
  }
}

class _StudyMenu extends ConsumerWidget {
  const _StudyMenu({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    return MenuAnchor(
      builder:
          (context, controller, _) => AppBarIconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            semanticsLabel: 'Study menu',
            icon: const Icon(Icons.more_horiz),
          ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.settings),
          semanticsLabel: context.l10n.settingsSettings,
          child: Text(context.l10n.settingsSettings),
          onPressed: () {
            Navigator.of(context).push(StudySettingsScreen.buildRoute(context, id));
          },
        ),
        MenuItemButton(
          closeOnActivate: false,
          leadingIcon: Icon(state.study.liked ? Icons.favorite : Icons.favorite_border),
          semanticsLabel: state.study.liked ? context.l10n.studyUnlike : context.l10n.studyLike,
          child: Text(state.study.liked ? context.l10n.studyUnlike : context.l10n.studyLike),
          onPressed: () {
            ref.read(studyControllerProvider(id).notifier).toggleLike();
          },
        ),
        MenuItemButton(
          leadingIcon: Icon(
            Theme.of(context).platform == TargetPlatform.iOS ? CupertinoIcons.share : Icons.share,
          ),
          semanticsLabel: context.l10n.studyShareAndExport,
          child: Text(context.l10n.studyShareAndExport),
          onPressed: () {
            showAdaptiveActionSheet<void>(
              context: context,
              actions: [
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyStudyUrl),
                  onPressed: (context) async {
                    launchShareDialog(context, uri: lichessUri('/study/${state.study.id}'));
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.studyCurrentChapterUrl),
                  onPressed: (context) async {
                    launchShareDialog(
                      context,
                      uri: lichessUri('/study/${state.study.id}/${state.study.chapter.id}'),
                    );
                  },
                ),
                if (!state.gamebookActive) ...[
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.studyStudyPgn),
                    onPressed: (context) async {
                      try {
                        final pgn = await ref
                            .read(studyRepositoryProvider)
                            .getStudyPgn(state.study.id);
                        if (context.mounted) {
                          launchShareDialog(context, text: pgn);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showPlatformSnackbar(
                            context,
                            'Failed to get PGN',
                            type: SnackBarType.error,
                          );
                        }
                      }
                    },
                  ),
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.studyChapterPgn),
                    onPressed: (context) async {
                      launchShareDialog(context, text: state.pgn);
                    },
                  ),
                  if (state.position != null)
                    BottomSheetAction(
                      makeLabel: (context) => Text(context.l10n.screenshotCurrentPosition),
                      onPressed: (_) async {
                        try {
                          final image = await ref
                              .read(gameShareServiceProvider)
                              .screenshotPosition(state.pov, state.position!.fen, state.lastMove);
                          if (context.mounted) {
                            launchShareDialog(
                              context,
                              files: [image],
                              subject: context.l10n.puzzleFromGameLink(
                                lichessUri('/study/${state.study.id}').toString(),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showPlatformSnackbar(
                              context,
                              'Failed to get GIF',
                              type: SnackBarType.error,
                            );
                          }
                        }
                      },
                    ),
                  BottomSheetAction(
                    makeLabel: (context) => const Text('GIF'),
                    onPressed: (_) async {
                      try {
                        final gif = await ref
                            .read(gameShareServiceProvider)
                            .chapterGif(state.study.id, state.study.chapter.id);
                        if (context.mounted) {
                          launchShareDialog(
                            context,
                            files: [gif],
                            subject: context.l10n.studyChapterX(
                              state.study.currentChapterMeta.name,
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        if (context.mounted) {
                          showPlatformSnackbar(
                            context,
                            'Failed to get GIF',
                            type: SnackBarType.error,
                          );
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

class _Body extends ConsumerWidget {
  const _Body({required this.id, required this.tabController, required this.tabs});

  final StudyId id;
  final TabController tabController;
  final List<AnalysisTab> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyState = ref.watch(studyControllerProvider(id)).requireValue;
    final variant = studyState.variant;
    if (!variant.isReadSupported) {
      return DefaultTabController(
        length: 1,
        child: AnalysisLayout(
          boardBuilder:
              (context, boardSize, borderRadius) => SizedBox.square(
                dimension: boardSize,
                child: Center(child: Text('${variant.label} is not supported yet.')),
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

    return AnalysisLayout(
      tabController: tabController,
      boardBuilder:
          (context, boardSize, borderRadius) =>
              _StudyBoard(id: id, boardSize: boardSize, borderRadius: borderRadius),
      engineGaugeBuilder:
          isComputerAnalysisAllowed && showEvaluationGauge && engineGaugeParams != null
              ? (context, orientation) {
                return orientation == Orientation.portrait
                    ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: engineGaugeParams,
                    )
                    : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: engineGaugeParams,
                      ),
                    );
              }
              : null,
      engineLines:
          isComputerAnalysisAllowed && isLocalEvaluationEnabled && numEvalLines > 0
              ? EngineLines(
                localEval: currentNode.eval,
                isGameOver: currentNode.position?.isGameOver ?? false,
                onTapMove: ref.read(studyControllerProvider(id).notifier).onUserMove,
              )
              : null,
      bottomBar: StudyBottomBar(id: id),
      children:
          tabs.map((tab) {
            switch (tab) {
              case AnalysisTab.opening:
                if (studyState.isOpeningExplorerAvailable &&
                    studyState.currentNode.position != null) {
                  return OpeningExplorerView(
                    position: studyState.currentNode.position!,
                    onMoveSelected: (move) {
                      ref.read(studyControllerProvider(id).notifier).onUserMove(move);
                    },
                  );
                } else {
                  return const Center(child: Text('Opening explorer not available.'));
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

class _StudyBoard extends ConsumerStatefulWidget {
  const _StudyBoard({required this.id, required this.boardSize, this.borderRadius});

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
    ref.listen(studyControllerProvider(widget.id).select((state) => state.hasValue), (prev, next) {
      if (prev != next) {
        setState(() {
          userShapes = ISet();
        });
      }
    });
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final studyState = ref.watch(studyControllerProvider(widget.id)).requireValue;

    final currentNode = studyState.currentNode;
    final position = currentNode.position;

    final showVariationArrows =
        ref.watch(studyPreferencesProvider.select((prefs) => prefs.showVariationArrows)) &&
        !studyState.gamebookActive &&
        currentNode.children.length > 1;

    final pgnShapes = ISet(studyState.pgnShapes.map((shape) => shape.chessground));

    final variationArrows = ISet<Shape>(
      showVariationArrows
          ? currentNode.children.mapIndexed((i, move) {
            final color = Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.5);
            return Arrow(color: color, orig: (move as NormalMove).from, dest: move.to);
          }).toList()
          : [],
    );

    final showAnnotationsOnBoard = ref.watch(
      analysisPreferencesProvider.select((value) => value.showAnnotations),
    );

    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select((value) => value.showBestMoveArrow),
    );
    final bestMoves = ref.watch(engineEvaluationProvider.select((s) => s.eval?.bestMoves));
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

    return InteractiveBoardWidget(
      size: widget.boardSize,
      boardPrefs: boardPrefs,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: widget.borderRadius,
        boxShadow: widget.borderRadius != null ? boardShadows : const <BoxShadow>[],
        drawShape: DrawShapeOptions(
          enable: true,
          onCompleteShape: _onCompleteShape,
          onClearShapes: _onClearShapes,
          newShapeColor: boardPrefs.shapeColor.color,
        ),
      ),
      fen: studyState.position?.board.fen ?? studyState.study.currentChapterMeta.fen ?? kInitialFEN,
      lastMove: studyState.lastMove as NormalMove?,
      orientation: studyState.pov,
      shapes: pgnShapes.union(userShapes).union(variationArrows).union(bestMoveShapes),
      annotations:
          showAnnotationsOnBoard && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation})
                  : IMap({sanMove.move.to: annotation})
              : null,
      gameData:
          position != null
              ? GameData(
                playerSide: studyState.playerSide,
                isCheck: position.isCheck,
                sideToMove: position.turn,
                validMoves: makeLegalMoves(position),
                promotionMove: studyState.promotionMove,
                onMove: (move, {isDrop, captured}) {
                  ref.read(studyControllerProvider(widget.id).notifier).onUserMove(move);
                },
                onPromotionSelection: (role) {
                  ref.read(studyControllerProvider(widget.id).notifier).onPromotionSelection(role);
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
