import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_settings_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/view/analysis/game_analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/server_analysis.dart';
import 'package:lichess_mobile/src/view/analysis/tree_view.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final _logger = Logger('AnalysisScreen');

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({required this.options, super.key});

  final AnalysisOptions options;

  static Route<dynamic> buildRoute(BuildContext context, AnalysisOptions options) {
    return buildScreenRoute(context, screen: AnalysisScreen(options: options));
  }

  @override
  Widget build(BuildContext context) {
    return _AnalysisScreen(options: options);
  }
}

class _AnalysisScreen extends ConsumerStatefulWidget {
  const _AnalysisScreen({required this.options});

  final AnalysisOptions options;

  @override
  ConsumerState<_AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<_AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late final List<AnalysisTab> tabs;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    tabs = [
      AnalysisTab.opening,
      AnalysisTab.moves,
      if (widget.options.isLichessGameAnalysis) AnalysisTab.summary,
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
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);

    final appBarActions = [
      if (asyncState.valueOrNull?.isEngineAvailable(enginePrefs) == true)
        EngineDepth(
          savedEval: asyncState.valueOrNull?.currentNode.eval,
          goDeeper: () => ref.read(ctrlProvider.notifier).requestEval(goDeeper: true),
        ),
      AppBarAnalysisTabIndicator(tabs: tabs, controller: _tabController),
      _AnalysisMenu(options: widget.options, state: asyncState),
    ];

    switch (asyncState) {
      case AsyncData(:final value):
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: false,
            title: _Title(variant: value.variant),
            actions: appBarActions,
          ),
          body: _Body(options: widget.options, controller: _tabController),
        );
      case AsyncError(:final error, :final stackTrace):
        _logger.severe('Cannot load analysis: $error', stackTrace);
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(ctrlProvider));
      case _:
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: false,
            title: const _Title(variant: Variant.standard),
            actions: appBarActions,
          ),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
    }
  }
}

class _AnalysisMenu extends ConsumerWidget {
  const _AnalysisMenu({required this.options, required this.state});

  final AnalysisOptions options;
  final AsyncValue<AnalysisState> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContextMenuIconButton(
      icon: const Icon(Icons.more_horiz),
      semanticsLabel: context.l10n.menu,
      actions: [
        ContextMenuAction(
          icon: Icons.settings,
          label: context.l10n.settingsSettings,
          onPressed: () => Navigator.of(
            context,
          ).push(AnalysisSettingsScreen.buildRoute(context, options: options)),
        ),
        ToggleSoundContextMenuAction(
          isEnabled: ref.watch(generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled)),
          onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
        ),
        ...(switch (state) {
          AsyncData(:final value) =>
            value.archivedGame != null
                ? [
                    GameBookmarkContextMenuAction(
                      id: value.archivedGame!.id,
                      bookmarked: value.archivedGame!.data.bookmarked ?? false,
                      onToggleBookmark: () =>
                          ref.read(analysisControllerProvider(options).notifier).toggleBookmark(),
                    ),
                    if (value.archivedGame!.finished)
                      ...makeFinishedGameShareContextMenuActions(
                        context,
                        ref,
                        gameId: value.archivedGame!.id,
                        orientation: value.pov,
                      ),
                  ]
                : [],
          _ => [],
        }),
      ],
    );
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
        Flexible(child: AppBarTitleText(context.l10n.analysis)),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.options, required this.controller});

  final TabController controller;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final showEvaluationGauge = analysisPrefs.showEvaluationGauge;
    final numEvalLines = enginePrefs.numEvalLines;

    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider).requireValue;

    final isEngineAvailable = analysisState.isEngineAvailable(enginePrefs);
    final currentNode = analysisState.currentNode;
    final pov = analysisState.pov;

    Widget? boardFooter;
    Widget? boardHeader;
    if (analysisState.archivedGame != null) {
      final hasClock =
          analysisState.isOnMainline &&
          analysisState.currentPosition.ply < analysisState.archivedGame!.steps.length;
      final footerPlayer = analysisState.archivedGame!.playerOf(pov);
      final headerPlayer = analysisState.archivedGame!.playerOf(pov.opposite);
      final footerClock = hasClock
          ? analysisState.archivedGame!.archivedClockOf(pov, analysisState.currentPosition.ply)
          : null;
      final headerClock = hasClock
          ? analysisState.archivedGame!.archivedClockOf(
              pov.opposite,
              analysisState.currentPosition.ply,
            )
          : null;
      boardFooter = _PlayerWidget(
        player: footerPlayer,
        clock: footerClock,
        isSideToMove: analysisState.currentPosition.turn == pov,
      );
      boardHeader = _PlayerWidget(
        player: headerPlayer,
        clock: headerClock,
        isSideToMove: analysisState.currentPosition.turn == pov.opposite,
      );
    }

    return AnalysisLayout(
      smallBoard: analysisPrefs.smallBoard,
      tabController: controller,
      pov: pov,
      boardBuilder: (context, boardSize, borderRadius) =>
          GameAnalysisBoard(options: options, boardSize: boardSize, boardRadius: borderRadius),
      boardHeader: boardHeader,
      boardFooter: boardFooter,
      engineGaugeBuilder: analysisState.hasAvailableEval(enginePrefs) && showEvaluationGauge
          ? (context, orientation) {
              return orientation == Orientation.portrait
                  ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: analysisState.engineGaugeParams(enginePrefs),
                      engineLinesState: isEngineAvailable && numEvalLines > 0
                          ? analysisPrefs.showEngineLines
                                ? EngineLinesShowState.expanded
                                : EngineLinesShowState.collapsed
                          : null,
                      onTap: () {
                        ref.read(analysisPreferencesProvider.notifier).toggleShowEngineLines();
                      },
                    )
                  : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: analysisState.engineGaugeParams(enginePrefs),
                      ),
                    );
            }
          : null,
      engineLines: isEngineAvailable && numEvalLines > 0 && analysisPrefs.showEngineLines
          ? EngineLines(
              onTapMove: ref.read(ctrlProvider.notifier).onUserMove,
              savedEval: currentNode.eval,
              isGameOver: currentNode.position.isGameOver,
            )
          : null,
      bottomBar: _BottomBar(options: options),
      children: [
        OpeningExplorerView(
          shouldDisplayGames: analysisState.isComputerAnalysisAllowed,
          position: currentNode.position,
          opening: kOpeningAllowedVariants.contains(analysisState.variant)
              ? analysisState.currentNode.isRoot
                    ? LightOpening(eco: '', name: context.l10n.startPosition)
                    : analysisState.currentNode.opening ?? analysisState.currentBranchOpening
              : null,
          onMoveSelected: (move) {
            ref.read(ctrlProvider.notifier).onUserMove(move);
          },
        ),
        AnalysisTreeView(options),
        if (options.isLichessGameAnalysis) ServerAnalysisSummary(options),
      ],
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({required this.player, required this.clock, required this.isSideToMove});

  final Player player;
  final Duration? clock;
  final bool isSideToMove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kAnalysisBoardHeaderOrFooterHeight,
      color: ColorScheme.of(context).surfaceContainer,
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (player.user != null)
            UserFullNameWidget.player(
              user: player.user,
              rating: player.rating,
              provisional: player.provisional,
              aiLevel: player.aiLevel,
            )
          else
            Text(player.fullName(context.l10n)),
          if (clock != null) _Clock(timeLeft: clock!, isSideToMove: isSideToMove),
        ],
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock({required this.timeLeft, required this.isSideToMove});

  final Duration timeLeft;
  final bool isSideToMove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Container(
      height: kAnalysisBoardHeaderOrFooterHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: isSideToMove ? colorScheme.secondaryContainer : null,
      child: Center(
        child: Text(
          timeLeft.toHoursMinutesSeconds(),
          style: TextStyle(
            color: isSideToMove ? colorScheme.onSecondaryContainer : null,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
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
    final evalPrefs = ref.watch(engineEvaluationPreferencesProvider);

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showAnalysisMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        if (analysisState.isComputerAnalysisAllowed)
          Builder(
            builder: (context) {
              Future<void>? toggleFuture;
              return FutureBuilder(
                future: toggleFuture,
                builder: (context, snapshot) {
                  return BottomBarButton(
                    label: context.l10n.toggleLocalEvaluation,
                    onTap:
                        analysisState.isEngineAllowed &&
                            snapshot.connectionState != ConnectionState.waiting
                        ? () async {
                            toggleFuture = ref.read(ctrlProvider.notifier).toggleEngine();
                            try {
                              await toggleFuture;
                            } finally {
                              toggleFuture = null;
                            }
                          }
                        : null,
                    icon: CupertinoIcons.gauge,
                    highlighted: analysisState.isEngineAvailable(evalPrefs),
                  );
                },
              );
            },
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
    final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: () => ref.read(analysisControllerProvider(options).notifier).toggleBoard(),
        ),
        // board editor can be used to quickly analyze a position, so engine must be allowed to access
        if (analysisState.isComputerAnalysisAllowed)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.boardEditor),
            onPressed: () {
              final boardFen = analysisState.currentPosition.fen;
              Navigator.of(
                context,
              ).push(BoardEditorScreen.buildRoute(context, initialFen: boardFen));
            },
          ),
        if (analysisState.gameId != null || analysisState.isComputerAnalysisAllowed)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.studyShareAndExport),
            onPressed: () => _showShareMenu(context, ref),
          ),
      ],
    );
  }

  Future<void> _showShareMenu(BuildContext context, WidgetRef ref) {
    final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        // PGN share can be used to quickly analyze a position, so engine must be allowed to access
        if (analysisState.isComputerAnalysisAllowed)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
            onPressed: () {
              Navigator.of(context).push(AnalysisShareScreen.buildRoute(context, options: options));
            },
          ),
        // share position as FEN can be used to quickly analyze a position, so engine must be allowed to access
        if (analysisState.isComputerAnalysisAllowed)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
            onPressed: () {
              final analysisState = ref.read(analysisControllerProvider(options)).requireValue;
              launchShareDialog(context, ShareParams(text: analysisState.currentPosition.fen));
            },
          ),
      ],
    );
  }
}
