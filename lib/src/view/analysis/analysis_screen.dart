import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/view/analysis/server_analysis.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

import '../../utils/share.dart';
import 'analysis_board.dart';
import 'analysis_settings.dart';
import 'tree_view.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.options,
    required this.pgnOrId,
    this.enableDrawingShapes = true,
  });

  /// The analysis options.
  final AnalysisOptions options;

  /// The PGN or game ID to load.
  final String pgnOrId;

  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context) {
    return pgnOrId.length == 8 && GameId(pgnOrId).isValid
        ? _LoadGame(
            GameId(pgnOrId),
            options,
            enableDrawingShapes: enableDrawingShapes,
          )
        : _LoadedAnalysisScreen(
            options: options,
            pgn: pgnOrId,
            enableDrawingShapes: enableDrawingShapes,
          );
  }
}

class _LoadGame extends ConsumerWidget {
  const _LoadGame(
    this.gameId,
    this.options, {
    required this.enableDrawingShapes,
  });

  final AnalysisOptions options;
  final GameId gameId;

  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(archivedGameProvider(id: gameId));

    return gameAsync.when(
      data: (game) {
        final serverAnalysis =
            game.white.analysis != null && game.black.analysis != null
                ? (white: game.white.analysis!, black: game.black.analysis!)
                : null;
        return _LoadedAnalysisScreen(
          options: options.copyWith(
            id: game.id,
            opening: game.meta.opening,
            division: game.meta.division,
            serverAnalysis: serverAnalysis,
          ),
          pgn: game.makePgn(),
          enableDrawingShapes: enableDrawingShapes,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) {
        return Center(
          child: Text('Cannot load game analysis: $error'),
        );
      },
    );
  }
}

class _LoadedAnalysisScreen extends ConsumerStatefulWidget {
  const _LoadedAnalysisScreen({
    required this.options,
    required this.pgn,
    required this.enableDrawingShapes,
  });

  final AnalysisOptions options;
  final String pgn;

  final bool enableDrawingShapes;

  @override
  ConsumerState<_LoadedAnalysisScreen> createState() =>
      _LoadedAnalysisScreenState();
}

class _LoadedAnalysisScreenState extends ConsumerState<_LoadedAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<AnalysisTab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      const AnalysisTab(
        title: 'Moves',
        icon: LichessIcons.flow_cascade,
      ),
      if (widget.options.canShowGameSummary)
        const AnalysisTab(
          title: 'Summary',
          icon: Icons.area_chart,
        ),
    ];

    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
    final currentNodeEval =
        ref.watch(ctrlProvider.select((value) => value.currentNode.eval));

    return PlatformScaffold(
      resizeToAvoidBottomInset: false,
      appBar: PlatformAppBar(
        title: _Title(options: widget.options),
        actions: [
          EngineDepth(defaultEval: currentNodeEval),
          AppBarAnalysisTabIndicator(
            tabs: tabs,
            controller: _tabController,
          ),
          AppBarIconButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              isDismissible: true,
              builder: (_) => AnalysisSettings(widget.pgn, widget.options),
            ),
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _Body(
        controller: _tabController,
        pgn: widget.pgn,
        options: widget.options,
        enableDrawingShapes: widget.enableDrawingShapes,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.options});
  final AnalysisOptions options;

  static const excludedIcons = [Variant.standard, Variant.fromPosition];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!excludedIcons.contains(options.variant)) ...[
          Icon(options.variant.icon),
          const SizedBox(width: 5.0),
        ],
        Text(context.l10n.analysis),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.controller,
    required this.pgn,
    required this.options,
    required this.enableDrawingShapes,
  });

  final TabController controller;
  final String pgn;
  final AnalysisOptions options;
  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showEvaluationGauge = ref.watch(
      analysisPreferencesProvider.select((value) => value.showEvaluationGauge),
    );

    final ctrlProvider = analysisControllerProvider(pgn, options);
    final analysisState = ref.watch(ctrlProvider);

    final isEngineAvailable = analysisState.isEngineAvailable;
    final hasEval = analysisState.hasAvailableEval;
    final currentNode = analysisState.currentNode;

    return AnalysisLayout(
      tabController: controller,
      boardBuilder: (context, boardSize, borderRadius) => AnalysisBoard(
        pgn,
        options,
        boardSize,
        borderRadius: borderRadius,
        enableDrawingShapes: enableDrawingShapes,
      ),
      engineGaugeBuilder: hasEval && showEvaluationGauge
          ? (context, orientation) {
              return orientation == Orientation.portrait
                  ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: analysisState.engineGaugeParams,
                    )
                  : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: analysisState.engineGaugeParams,
                      ),
                    );
            }
          : null,
      engineLines: isEngineAvailable
          ? EngineLines(
              onTapMove: ref.read(ctrlProvider.notifier).onUserMove,
              clientEval: currentNode.eval,
              isGameOver: currentNode.position.isGameOver,
            )
          : null,
      bottomBar: _BottomBar(pgn: pgn, options: options),
      children: [
        AnalysisTreeView(pgn, options),
        if (options.canShowGameSummary) ServerAnalysisSummary(pgn, options),
      ],
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final analysisState = ref.watch(ctrlProvider);

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showAnalysisMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        RepeatButton(
          onLongPress:
              analysisState.canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: analysisState.canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: analysisState.canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref
                .read(analysisControllerProvider(pgn, options).notifier)
                .toggleBoard();
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.boardEditor),
          onPressed: (context) {
            final analysisState =
                ref.read(analysisControllerProvider(pgn, options));
            final boardFen = analysisState.position.fen;
            pushPlatformRoute(
              context,
              title: context.l10n.boardEditor,
              builder: (_) => BoardEditorScreen(
                initialFen: boardFen,
              ),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
          onPressed: (_) {
            pushPlatformRoute(
              context,
              title: context.l10n.studyShareAndExport,
              builder: (_) => AnalysisShareScreen(pgn: pgn, options: options),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
          onPressed: (_) {
            final analysisState =
                ref.read(analysisControllerProvider(pgn, options));
            launchShareDialog(
              context,
              text: analysisState.position.fen,
            );
          },
        ),
        if (options.gameAnyId != null)
          BottomSheetAction(
            makeLabel: (context) =>
                Text(context.l10n.screenshotCurrentPosition),
            onPressed: (_) async {
              final gameId = options.gameAnyId!.gameId;
              final analysisState =
                  ref.read(analysisControllerProvider(pgn, options));
              try {
                final image =
                    await ref.read(gameShareServiceProvider).screenshotPosition(
                          gameId,
                          options.orientation,
                          analysisState.position.fen,
                          analysisState.lastMove,
                        );
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(
                      lichessUri('/$gameId').toString(),
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
      ],
    );
  }
}
