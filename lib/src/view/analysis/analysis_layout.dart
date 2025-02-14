import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

/// The height of the board header or footer in the analysis layout.
const kAnalysisBoardHeaderOrFooterHeight = 26.0;

typedef BoardBuilder =
    Widget Function(BuildContext context, double boardSize, BorderRadius? boardRadius);

typedef EngineGaugeBuilder = Widget Function(BuildContext context, Orientation orientation);

enum AnalysisTab {
  opening(Icons.explore),
  moves(LichessIcons.flow_cascade),
  summary(Icons.area_chart);

  const AnalysisTab(this.icon);

  final IconData icon;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case AnalysisTab.opening:
        return l10n.openingExplorer;
      case AnalysisTab.moves:
        return l10n.movesPlayed;
      case AnalysisTab.summary:
        return l10n.computerAnalysis;
    }
  }
}

/// Indicator for the analysis tab, typically shown in the app bar.
class AppBarAnalysisTabIndicator extends StatefulWidget {
  const AppBarAnalysisTabIndicator({required this.tabs, required this.controller, super.key});

  final TabController controller;

  /// Typically a list of two or more [AnalysisTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [AnalysisLayout.children] list.
  final List<AnalysisTab> tabs;

  @override
  State<AppBarAnalysisTabIndicator> createState() => _AppBarAnalysisTabIndicatorState();
}

class _AppBarAnalysisTabIndicatorState extends State<AppBarAnalysisTabIndicator> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.animation?.addListener(_handleTabAnimationTick);
    widget.controller.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.controller.animation?.removeListener(_handleTabAnimationTick);
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabAnimationTick() {
    if (widget.controller.indexIsChanging) {
      setState(() {
        // Rebuild the widget when the tab index is changing.
      });
    }
  }

  void _handleTabChange() {
    setState(() {
      // Rebuild the widget when the tab changes.
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      icon: Icon(widget.tabs[widget.controller.index].icon),
      semanticsLabel: widget.tabs[widget.controller.index].l10n(context.l10n),
      onPressed: () {
        showAdaptiveActionSheet<void>(
          context: context,
          actions:
              widget.tabs.map((tab) {
                return BottomSheetAction(
                  leading: Icon(tab.icon),
                  makeLabel: (context) => Text(tab.l10n(context.l10n)),
                  onPressed: () {
                    widget.controller.animateTo(widget.tabs.indexOf(tab));
                  },
                );
              }).toList(),
        );
      },
    );
  }
}

/// Layout for the analysis and similar screens (study, broadcast, etc.).
///
/// The layout is responsive and adapts to the screen size and orientation.
///
/// It includes a [TabBarView] with the [children] widgets. If a [TabController]
/// is not provided, then there must be a [DefaultTabController] ancestor.
///
/// The length of the [children] list must match the [tabController]'s
/// [TabController.length] and the length of the [AppBarAnalysisTabIndicator.tabs]
class AnalysisLayout extends StatelessWidget {
  const AnalysisLayout({
    this.tabController,
    required this.boardBuilder,
    required this.children,
    required this.pov,
    this.boardHeader,
    this.boardFooter,
    this.engineGaugeBuilder,
    this.engineLines,
    this.bottomBar,
    super.key,
  });

  /// The tab controller for the tab view.
  final TabController? tabController;

  /// The builder for the board widget.
  final BoardBuilder boardBuilder;

  /// The side the board is displayed from.
  final Side pov;

  /// A widget to show above the board.
  ///
  /// The widget will included in a parent container with a height of
  /// [kAnalysisBoardHeaderOrFooterHeight].
  final Widget? boardHeader;

  /// A widget to show below the board.
  ///
  /// The widget will included in a parent container with a height of
  /// [kAnalysisBoardHeaderOrFooterHeight].
  final Widget? boardFooter;

  /// The children of the tab view.
  ///
  /// The length of this list must match the [tabController]'s [TabController.length]
  /// and the length of the [AppBarAnalysisTabIndicator.tabs] list.
  final List<Widget> children;

  /// A builder for the engine gauge widget.
  final EngineGaugeBuilder? engineGaugeBuilder;

  /// A widget to show below the engine gauge, typically the engine lines.
  final Widget? engineLines;

  /// A widget to show at the bottom of the screen.
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final orientation =
                    constraints.maxWidth > constraints.maxHeight
                        ? Orientation.landscape
                        : Orientation.portrait;
                final isTablet = isTabletOrLarger(context);
                const tabletBoardRadius = Styles.boardBorderRadius;

                if (orientation == Orientation.landscape) {
                  final headerAndFooterHeight =
                      (boardHeader != null ? kAnalysisBoardHeaderOrFooterHeight : 0.0) +
                      (boardFooter != null ? kAnalysisBoardHeaderOrFooterHeight : 0.0);
                  final sideWidth =
                      constraints.biggest.longestSide - constraints.biggest.shortestSide;
                  final defaultBoardSize =
                      constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
                  final boardSize =
                      (sideWidth >= 250
                          ? defaultBoardSize
                          : constraints.biggest.longestSide / kGoldenRatio -
                              (kTabletBoardTableSidePadding * 2)) -
                      headerAndFooterHeight;
                  return Padding(
                    padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            if (boardHeader != null)
                              Container(
                                // This key is used to preserve the state of the board header when the pov changes
                                key: ValueKey(pov.opposite),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      isTablet
                                          ? tabletBoardRadius.copyWith(
                                            bottomLeft: Radius.zero,
                                            bottomRight: Radius.zero,
                                          )
                                          : null,
                                ),
                                clipBehavior: isTablet ? Clip.hardEdge : Clip.none,
                                child: SizedBox(
                                  height: kAnalysisBoardHeaderOrFooterHeight,
                                  width: boardSize,
                                  child: boardHeader,
                                ),
                              ),
                            boardBuilder(
                              context,
                              boardSize,
                              isTablet && boardHeader == null && boardFooter != null
                                  ? tabletBoardRadius
                                  : null,
                            ),
                            if (boardFooter != null)
                              Container(
                                // This key is used to preserve the state of the board footer when the pov changes
                                key: ValueKey(pov),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      isTablet
                                          ? tabletBoardRadius.copyWith(
                                            topLeft: Radius.zero,
                                            topRight: Radius.zero,
                                          )
                                          : null,
                                ),
                                clipBehavior: isTablet ? Clip.hardEdge : Clip.none,
                                height: kAnalysisBoardHeaderOrFooterHeight,
                                width: boardSize,
                                child: boardFooter,
                              ),
                          ],
                        ),
                        if (engineGaugeBuilder != null) ...[
                          const SizedBox(width: 4.0),
                          engineGaugeBuilder!(context, Orientation.landscape),
                        ],
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (engineLines != null) engineLines!,
                              Expanded(
                                child: PlatformCard(
                                  clipBehavior: Clip.hardEdge,
                                  semanticContainer: false,
                                  child: TabBarView(controller: tabController, children: children),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final defaultBoardSize = constraints.biggest.shortestSide;
                  final remainingHeight = constraints.maxHeight - defaultBoardSize;
                  final isSmallScreen = remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                  final boardSize =
                      isTablet || isSmallScreen
                          ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                          : defaultBoardSize;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (engineGaugeBuilder != null)
                        engineGaugeBuilder!(context, Orientation.portrait),
                      if (engineLines != null) engineLines!,
                      Padding(
                        padding:
                            isTablet
                                ? const EdgeInsets.all(kTabletBoardTableSidePadding)
                                : EdgeInsets.zero,
                        child: Column(
                          children: [
                            if (boardHeader != null)
                              // This key is used to preserve the state of the board header when the pov changes
                              Container(
                                key: ValueKey(pov.opposite),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      isTablet
                                          ? tabletBoardRadius.copyWith(
                                            bottomLeft: Radius.zero,
                                            bottomRight: Radius.zero,
                                          )
                                          : null,
                                ),
                                clipBehavior: isTablet ? Clip.hardEdge : Clip.none,
                                height: kAnalysisBoardHeaderOrFooterHeight,
                                child: boardHeader,
                              ),
                            boardBuilder(
                              context,
                              boardSize,
                              isTablet && boardHeader == null && boardFooter != null
                                  ? tabletBoardRadius
                                  : null,
                            ),
                            if (boardFooter != null)
                              Container(
                                // This key is used to preserve the state of the board footer when the pov changes
                                key: ValueKey(pov),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      isTablet
                                          ? tabletBoardRadius.copyWith(
                                            topLeft: Radius.zero,
                                            topRight: Radius.zero,
                                          )
                                          : null,
                                ),
                                clipBehavior: isTablet ? Clip.hardEdge : Clip.none,
                                height: kAnalysisBoardHeaderOrFooterHeight,
                                child: boardFooter,
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              isTablet
                                  ? const EdgeInsets.symmetric(
                                    horizontal: kTabletBoardTableSidePadding,
                                  )
                                  : EdgeInsets.zero,
                          child: TabBarView(controller: tabController, children: children),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        if (bottomBar != null) bottomBar!,
      ],
    );
  }
}
