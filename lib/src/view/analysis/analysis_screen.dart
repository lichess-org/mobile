import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_settings.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/view/analysis/server_analysis.dart';
import 'package:lichess_mobile/src/view/analysis/tree_view.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:logging/logging.dart';

final _logger = Logger('AnalysisScreen');

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key, required this.options, this.enableDrawingShapes = true});

  final AnalysisOptions options;

  final bool enableDrawingShapes;

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late final List<AnalysisTab> tabs;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    tabs = [
      AnalysisTab.opening,
      AnalysisTab.moves,
      if (widget.options.gameId != null) AnalysisTab.summary,
    ];

    _tabController = TabController(vsync: this, initialIndex: 1, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.options);
    final asyncState = ref.watch(ctrlProvider);
    final prefs = ref.watch(analysisPreferencesProvider);

    final appBarActions = [
      if (prefs.enableComputerAnalysis)
        EngineDepth(defaultEval: asyncState.valueOrNull?.currentNode.eval),
      AppBarAnalysisTabIndicator(tabs: tabs, controller: _tabController),
      AppBarIconButton(
        onPressed: () {
          pushPlatformRoute(
            context,
            title: context.l10n.settingsSettings,
            builder: (_) => AnalysisSettings(widget.options),
          );
        },
        semanticsLabel: context.l10n.settingsSettings,
        icon: const Icon(Icons.settings),
      ),
    ];

    switch (asyncState) {
      case AsyncData(:final value):
        return PlatformScaffold(
          resizeToAvoidBottomInset: false,
          appBar: PlatformAppBar(title: _Title(variant: value.variant), actions: appBarActions),
          body: _Body(
            options: widget.options,
            controller: _tabController,
            enableDrawingShapes: widget.enableDrawingShapes,
          ),
        );
      case AsyncError(:final error, :final stackTrace):
        _logger.severe('Cannot load analysis: $error', stackTrace);
        return FullScreenRetryRequest(
          onRetry: () {
            ref.invalidate(ctrlProvider);
          },
        );
      case _:
        return PlatformScaffold(
          resizeToAvoidBottomInset: false,
          appBar: PlatformAppBar(
            title: const _Title(variant: Variant.standard),
            actions: appBarActions,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.variant});
  final Variant variant;

  static const excludedIcons = [Variant.standard, Variant.fromPosition];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!excludedIcons.contains(variant)) ...[Icon(variant.icon), const SizedBox(width: 5.0)],
        Flexible(
          child: AutoSizeText(
            context.l10n.analysis,
            minFontSize: 14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.options, required this.controller, required this.enableDrawingShapes});

  final TabController controller;
  final AnalysisOptions options;
  final bool enableDrawingShapes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final showEvaluationGauge = analysisPrefs.showEvaluationGauge;
    final numEvalLines = analysisPrefs.numEvalLines;

    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    final isEngineAvailable = analysisState.isEngineAvailable;
    final hasEval = analysisState.hasAvailableEval;
    final currentNode = analysisState.currentNode;

    return AnalysisLayout(
      tabController: controller,
      boardBuilder:
          (context, boardSize, borderRadius) => AnalysisBoard(
            options,
            boardSize,
            borderRadius: borderRadius,
            enableDrawingShapes: enableDrawingShapes,
          ),
      engineGaugeBuilder:
          hasEval && showEvaluationGauge
              ? (context, orientation) {
                return orientation == Orientation.portrait
                    ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: analysisState.engineGaugeParams,
                    )
                    : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: analysisState.engineGaugeParams,
                      ),
                    );
              }
              : null,
      engineLines:
          isEngineAvailable && numEvalLines > 0
              ? EngineLines(
                onTapMove: ref.read(ctrlProvider.notifier).onUserMove,
                clientEval: currentNode.eval,
                isGameOver: currentNode.position.isGameOver,
              )
              : null,
      bottomBar: _BottomBar(options: options),
      children: [
        OpeningExplorerView(
          position: currentNode.position,
          opening:
              kOpeningAllowedVariants.contains(analysisState.variant)
                  ? analysisState.currentNode.isRoot
                      ? LightOpening(eco: '', name: context.l10n.startPosition)
                      : analysisState.currentNode.opening ?? analysisState.currentBranchOpening
                  : null,
          onMoveSelected: (move) {
            ref.read(ctrlProvider.notifier).onUserMove(move);
          },
        ),
        AnalysisTreeView(options),
        if (options.gameId != null) ServerAnalysisSummary(options),
      ],
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showAnalysisMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        BottomBarButton(
          label: context.l10n.flipBoard,
          onTap: () => ref.read(ctrlProvider.notifier).toggleBoard(),
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: analysisState.canGoBack ? () => _moveBackward(ref) : null,
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
      ref.read(analysisControllerProvider(options).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userPrevious();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.boardEditor),
          onPressed: (context) {
            final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
            final boardFen = analysisState.position.fen;
            pushPlatformRoute(
              context,
              title: context.l10n.boardEditor,
              builder: (_) => BoardEditorScreen(initialFen: boardFen),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
          onPressed: (_) {
            pushPlatformRoute(
              context,
              title: context.l10n.studyShareAndExport,
              builder: (_) => AnalysisShareScreen(options: options),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
          onPressed: (_) {
            final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
            launchShareDialog(context, text: analysisState.position.fen);
          },
        ),
        if (options.gameId != null)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.screenshotCurrentPosition),
            onPressed: (_) async {
              final gameId = options.gameId!;
              final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
              try {
                final image = await ref
                    .read(gameShareServiceProvider)
                    .screenshotPosition(
                      analysisState.pov,
                      analysisState.position.fen,
                      analysisState.lastMove,
                    );
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(lichessUri('/$gameId').toString()),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showPlatformSnackbar(context, 'Failed to get GIF', type: SnackBarType.error);
                }
              }
            },
          ),
      ],
    );
  }
}
