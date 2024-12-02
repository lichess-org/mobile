import 'package:flutter/material.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

typedef BoardBuilder = Widget Function(
  BuildContext context,
  double boardSize,
  BorderRadius? boardRadius,
);

typedef EngineGaugeBuilder = Widget Function(
  BuildContext context,
  Orientation orientation,
);

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
  const AppBarAnalysisTabIndicator({
    required this.tabs,
    required this.controller,
    super.key,
  });

  final TabController controller;

  /// Typically a list of two or more [AnalysisTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [AnalysisLayout.children] list.
  final List<AnalysisTab> tabs;

  @override
  State<AppBarAnalysisTabIndicator> createState() =>
      _AppBarAnalysisTabIndicatorState();
}

class _AppBarAnalysisTabIndicatorState
    extends State<AppBarAnalysisTabIndicator> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      icon: Icon(widget.tabs[widget.controller.index].icon),
      semanticsLabel: widget.tabs[widget.controller.index].l10n(context.l10n),
      onPressed: () {
        showAdaptiveActionSheet<void>(
          context: context,
          actions: widget.tabs.map((tab) {
            return BottomSheetAction(
              leading: Icon(tab.icon),
              makeLabel: (context) => Text(tab.l10n(context.l10n)),
              onPressed: (_) {
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
    this.engineGaugeBuilder,
    this.engineLines,
    this.bottomBar,
    super.key,
  });

  /// The tab controller for the tab view.
  final TabController? tabController;

  /// The builder for the board widget.
  final BoardBuilder boardBuilder;

  /// The children of the tab view.
  ///
  /// The length of this list must match the [tabController]'s [TabController.length]
  /// and the length of the [AppBarAnalysisTabIndicator.tabs] list.
  final List<Widget> children;

  final EngineGaugeBuilder? engineGaugeBuilder;
  final Widget? engineLines;
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
                final orientation = constraints.maxWidth > constraints.maxHeight
                    ? Orientation.landscape
                    : Orientation.portrait;
                final isTablet = isTabletOrLarger(context);
                const tabletBoardRadius =
                    BorderRadius.all(Radius.circular(4.0));

                if (orientation == Orientation.landscape) {
                  final sideWidth = constraints.biggest.longestSide -
                      constraints.biggest.shortestSide;
                  final defaultBoardSize = constraints.biggest.shortestSide -
                      (kTabletBoardTableSidePadding * 2);
                  final boardSize = sideWidth >= 250
                      ? defaultBoardSize
                      : constraints.biggest.longestSide / kGoldenRatio -
                          (kTabletBoardTableSidePadding * 2);
                  return Padding(
                    padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        boardBuilder(
                          context,
                          boardSize,
                          isTablet ? tabletBoardRadius : null,
                        ),
                        if (engineGaugeBuilder != null) ...[
                          const SizedBox(width: 4.0),
                          engineGaugeBuilder!(
                            context,
                            Orientation.landscape,
                          ),
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
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  semanticContainer: false,
                                  child: TabBarView(
                                    controller: tabController,
                                    children: children,
                                  ),
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
                  final remainingHeight =
                      constraints.maxHeight - defaultBoardSize;
                  final isSmallScreen =
                      remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                  final boardSize = isTablet || isSmallScreen
                      ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                      : defaultBoardSize;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (engineGaugeBuilder != null)
                        engineGaugeBuilder!(
                          context,
                          Orientation.portrait,
                        ),
                      if (engineLines != null) engineLines!,
                      Padding(
                        padding: isTablet
                            ? const EdgeInsets.all(
                                kTabletBoardTableSidePadding,
                              )
                            : EdgeInsets.zero,
                        child: boardBuilder(
                          context,
                          boardSize,
                          isTablet ? tabletBoardRadius : null,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: isTablet
                              ? const EdgeInsets.symmetric(
                                  horizontal: kTabletBoardTableSidePadding,
                                )
                              : EdgeInsets.zero,
                          child: TabBarView(
                            controller: tabController,
                            children: children,
                          ),
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
