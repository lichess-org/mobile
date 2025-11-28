import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
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
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/explorer/explorer_view.dart';
import 'package:lichess_mobile/src/view/study/study_bottom_bar.dart';
import 'package:lichess_mobile/src/view/study/study_gamebook.dart';
import 'package:lichess_mobile/src/view/study/study_settings.dart';
import 'package:lichess_mobile/src/view/study/study_tree_view.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

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
    final studyPrefs = ref.watch(studyPreferencesProvider);
    switch (ref.watch(studyControllerProvider(id))) {
      case AsyncData(:final value):
        return _StudyScreen(id: id, studyState: value);
      case AsyncError(:final error, :final stackTrace):
        _logger.severe('Cannot load study: $error', stackTrace);
        return Scaffold(
          appBar: AppBar(title: const Text('')),
          body: DefaultTabController(
            length: 1,
            child: AnalysisLayout(
              smallBoard: studyPrefs.smallBoard,
              pov: Side.white,
              boardBuilder: (context, boardSize, borderRadius) => Chessboard.fixed(
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
              smallBoard: studyPrefs.smallBoard,
              pov: Side.white,
              boardBuilder: (context, boardSize, borderRadius) => Chessboard.fixed(
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
      if (widget.studyState.isOpeningExplorerAvailable) AnalysisTab.explorer,
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
      tabs = [AnalysisTab.explorer, AnalysisTab.moves];
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
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleText(widget.studyState.currentChapterTitle, maxLines: 2),
        actions: [
          if (tabs.length > 1) AppBarAnalysisTabIndicator(tabs: tabs, controller: _tabController),
          _StudyMenu(id: widget.id),
        ],
      ),
      body: _Body(id: widget.id, tabController: _tabController, tabs: tabs),
    );
  }
}

class _StudyMenu extends ConsumerWidget {
  const _StudyMenu({required this.id});

  final StudyId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider);
    final state = ref.watch(studyControllerProvider(id)).requireValue;
    final kidModeAsync = ref.watch(kidModeProvider);

    return ContextMenuIconButton(
      semanticsLabel: 'Study menu',
      icon: const Icon(Icons.more_horiz),
      actions: [
        ContextMenuAction(
          icon: Icons.settings,
          label: context.l10n.settingsSettings,
          onPressed: () {
            Navigator.of(context).push(StudySettingsScreen.buildRoute(context, id));
          },
        ),
        if (authUser != null)
          ContextMenuAction(
            icon: state.study.liked ? Icons.favorite : Icons.favorite_border,
            label: state.study.liked ? context.l10n.studyUnlike : context.l10n.studyLike,
            onPressed: () {
              ref.read(studyControllerProvider(id).notifier).toggleLike();
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
        ContextMenuAction(
          label: context.l10n.studyMembers,
          icon: Icons.group_outlined,
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            isDismissible: true,
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
            builder: (_) => DraggableScrollableSheet(
              initialChildSize: 0.6,
              snap: true,
              expand: false,
              builder: (context, scrollController) {
                return _StudyMembersSheet(id: state.study.id, scrollController: scrollController);
              },
            ),
          ),
        ),
        if (state.chatOptions != null && kidModeAsync.value == false)
          ContextMenuAction(
            label: context.l10n.chatRoom,
            onPressed: () {
              Navigator.of(
                context,
              ).push(ChatScreen.buildRoute(context, options: state.chatOptions!));
            },
            icon: Icons.chat_bubble_outline,
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
    final studyPrefs = ref.watch(studyPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final variant = studyState.variant;
    if (!variant.isReadSupported) {
      return DefaultTabController(
        length: 1,
        child: AnalysisLayout(
          smallBoard: studyPrefs.smallBoard,

          pov: Side.white,
          boardBuilder: (context, boardSize, borderRadius) => SizedBox.square(
            dimension: boardSize,
            child: Center(child: Text('${variant.label} is not supported yet.')),
          ),
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
    final currentNode = studyState.currentNode;
    final pov = studyState.pov;

    final bottomChild = gamebookActive ? StudyGamebook(id) : StudyTreeView(id);

    return AnalysisLayout(
      smallBoard: studyPrefs.smallBoard,
      tabController: tabController,
      pov: pov,
      boardBuilder: (context, boardSize, borderRadius) =>
          StudyAnalysisBoard(id: id, boardSize: boardSize, boardRadius: borderRadius),
      engineGaugeBuilder:
          isComputerAnalysisAllowed && showEvaluationGauge && engineGaugeParams != null
          ? (context) {
              return EngineGauge(
                params: engineGaugeParams,
                onTap: () {
                  ref.read(studyPreferencesProvider.notifier).toggleShowEngineLines();
                },
              );
            }
          : null,
      engineLines:
          isComputerAnalysisAllowed &&
              studyPrefs.showEngineLines &&
              isLocalEvaluationEnabled &&
              numEvalLines > 0
          ? EngineLines(
              savedEval: currentNode.eval,
              isGameOver: currentNode.position?.isGameOver ?? false,
              onTapMove: ref.read(studyControllerProvider(id).notifier).onUserMove,
            )
          : null,
      bottomBar: StudyBottomBar(id: id),
      children: tabs.map((tab) {
        switch (tab) {
          case AnalysisTab.explorer:
            if (studyState.isOpeningExplorerAvailable && studyState.currentNode.position != null) {
              return ExplorerView(
                pov: pov,
                position: studyState.currentNode.position!,
                onMoveSelected: (move) {
                  ref.read(studyControllerProvider(id).notifier).onUserMove(move);
                },
                isComputerAnalysisAllowed: true,
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

class StudyAnalysisBoard extends AnalysisBoard {
  const StudyAnalysisBoard({required this.id, required super.boardSize, super.boardRadius});

  final StudyId id;

  @override
  ConsumerState<StudyAnalysisBoard> createState() => _StudyAnalysisBoardState();
}

class _StudyAnalysisBoardState
    extends AnalysisBoardState<StudyAnalysisBoard, StudyState, StudyPrefs> {
  @override
  StudyState get analysisState => ref.watch(studyControllerProvider(widget.id)).requireValue;

  @override
  StudyPrefs get analysisPrefs => ref.watch(studyPreferencesProvider);

  @override
  bool get showAnnotations => analysisPrefs.showAnnotations;

  @override
  void onUserMove(NormalMove move) {
    ref.read(studyControllerProvider(widget.id).notifier).onUserMove(move);
  }

  @override
  void onPromotionSelection(Role? role) {
    ref.read(studyControllerProvider(widget.id).notifier).onPromotionSelection(role);
  }

  @override
  String get fen =>
      analysisState.currentPosition?.board.fen ??
      analysisState.study.currentChapterMeta.fen ??
      kInitialFEN;

  @override
  ISet<Shape> get extraShapes {
    final showVariationArrows =
        ref.watch(studyPreferencesProvider.select((prefs) => prefs.showVariationArrows)) &&
        !analysisState.gamebookActive &&
        analysisState.currentNode.children.length > 1;

    final pgnShapes = ISet(analysisState.pgnShapes.map((shape) => shape.chessground));

    final variationArrows = ISet<Shape>(
      showVariationArrows
          ? analysisState.currentNode.children.mapIndexed((i, move) {
              final color = Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.5);
              return Arrow(color: color, orig: (move as NormalMove).from, dest: move.to);
            }).toList()
          : [],
    );

    return pgnShapes.union(variationArrows);
  }

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

    return super.build(context);
  }
}

class _StudyMembersSheet extends ConsumerWidget {
  const _StudyMembersSheet({required this.id, required this.scrollController});

  final StudyId id;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(id)).requireValue;

    return BottomSheetScrollableContainer(
      scrollController: scrollController,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.studyNbMembers(state.study.members.length),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        for (final member in state.study.members.values)
          ListTile(
            title: UserFullNameWidget(user: member.user),
            onTap: () {
              Navigator.of(context).push(UserOrProfileScreen.buildRoute(context, member.user));
            },
          ),
      ],
    );
  }
}
