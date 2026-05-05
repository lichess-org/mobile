import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pockets.dart';

/// The height of the board header or footer in the analysis layout.
const kAnalysisBoardHeaderOrFooterHeight = 26.0;

/// Scale factor for the small board in portrait orientation.
const kSmallBoardScale = 0.8;

typedef BoardBuilder =
    Widget Function(BuildContext context, double boardSize, BorderRadius? boardRadius);

typedef EngineGaugeBuilder = Widget Function(BuildContext context);

enum AnalysisTab {
  pgn(Icons.sell_outlined),
  explorer(Icons.explore),
  moves(LichessIcons.flow_cascade),
  summary(Icons.area_chart),
  conditionalPremoves(Icons.save);

  const AnalysisTab(this.icon);

  final IconData icon;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case AnalysisTab.pgn:
        return l10n.studyPgnTags;
      case AnalysisTab.explorer:
        return l10n.openingExplorerAndTablebase;
      case AnalysisTab.moves:
        return l10n.movesPlayed;
      case AnalysisTab.summary:
        return l10n.computerAnalysis;
      case AnalysisTab.conditionalPremoves:
        return l10n.conditionalPremoves;
    }
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
class AnalysisLayout extends ConsumerWidget {
  const AnalysisLayout({
    this.tabController,
    this.tabs,
    required this.boardBuilder,
    required this.children,
    required this.pov,
    required this.sideToMove,
    this.boardHeader,
    this.boardFooter,
    this.engineGaugeBuilder,
    this.engineLines,
    this.bottomBar,
    this.pockets,
    super.key,
  });

  /// The tab controller for the tab view.
  final TabController? tabController;

  /// If non-null, a tab indicator bar will be shown above the tab view.
  final List<AnalysisTab>? tabs;

  /// The builder for the board widget.
  final BoardBuilder boardBuilder;

  /// The side the board is displayed from.
  final Side pov;

  /// The side to move. In crazyhouse, this enables the [PocketsMenu] of this side.
  final Side? sideToMove;

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
  /// and the length of the [tabs] list.
  final List<Widget> children;

  /// A builder for the engine gauge widget.
  final EngineGaugeBuilder? engineGaugeBuilder;

  /// A widget to show below the engine gauge, typically the engine lines.
  final Widget? engineLines;

  /// A widget to show at the bottom of the screen.
  final Widget? bottomBar;

  /// Current state of the pockets, in variants like crazyhouse.
  ///
  /// If not null, will render a [PocketsMenu] for each player.
  final Pockets? pockets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                const tabletBoardRadius = Styles.boardBorderRadius;

                final playerSide = switch (sideToMove) {
                  Side.white => PlayerSide.white,
                  Side.black => PlayerSide.black,
                  null => PlayerSide.none,
                };

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

                  final boardPrefs = ref.watch(boardPreferencesProvider);

                  return Padding(
                    padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                    child: Row(
                      textDirection: switch (boardPrefs.landscapeBoardPosition) {
                        .left => TextDirection.ltr,
                        .right => TextDirection.rtl,
                      },
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            if (boardHeader != null)
                              Container(
                                // This key is used to preserve the state of the board header when the pov changes
                                key: ValueKey(pov.opposite),
                                decoration: BoxDecoration(
                                  borderRadius: isTablet
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
                                  borderRadius: isTablet
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
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                            child: engineGaugeBuilder!(context),
                          ),
                        ],
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (engineLines != null) engineLines!,
                              if (pockets != null)
                                Align(
                                  alignment: Alignment.center,
                                  child: PocketsMenu(
                                    side: pov.opposite,
                                    sideToMove: sideToMove,
                                    playerSide: playerSide,
                                    pockets: pockets!,
                                    squareSize: pocketSquareSize(
                                      boardSize: boardSize,
                                      isTablet: isTablet,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  semanticContainer: false,
                                  child: _AnalysisTabView(
                                    tabs: tabs,
                                    controller: tabController,
                                    children: children,
                                  ),
                                ),
                              ),
                              if (pockets != null)
                                Align(
                                  alignment: Alignment.center,
                                  child: PocketsMenu(
                                    side: pov,
                                    sideToMove: sideToMove,
                                    playerSide: playerSide,
                                    pockets: pockets!,
                                    squareSize: pocketSquareSize(
                                      boardSize: boardSize,
                                      isTablet: isTablet,
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
                  final evalGaugeWidth = getEvalGaugeWidth(context);
                  final defaultBoardSize = constraints.biggest.shortestSide;
                  final remainingHeight = constraints.maxHeight - defaultBoardSize;
                  final isSmallScreen = remainingHeight < kSmallHeightMinusBoard;
                  final evalGaugeSize = engineGaugeBuilder != null ? evalGaugeWidth : 0.0;
                  final additionalBoardSidePaddingForPockets = isSmallScreen ? 70.0 : 16.0;
                  final boardSize = isTablet || isSmallScreen || pockets != null
                      ? defaultBoardSize -
                            evalGaugeSize -
                            kTabletBoardTableSidePadding * 2 -
                            (pockets != null ? additionalBoardSidePaddingForPockets : 0.0)
                      : defaultBoardSize - evalGaugeSize;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (engineLines != null) engineLines!,
                      Padding(
                        padding: isTablet
                            ? const EdgeInsets.all(kTabletBoardTableSidePadding)
                            : EdgeInsets.zero,
                        child: Column(
                          children: [
                            if (pockets != null)
                              PocketsMenu(
                                side: pov.opposite,
                                sideToMove: sideToMove,
                                playerSide: playerSide,
                                pockets: pockets!,
                                squareSize: pocketSquareSize(
                                  boardSize: boardSize,
                                  isTablet: isTablet,
                                ),
                              ),
                            if (boardHeader != null)
                              // This key is used to preserve the state of the board header when the pov changes
                              Container(
                                key: ValueKey(pov.opposite),
                                decoration: BoxDecoration(
                                  borderRadius: isTablet
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                boardBuilder(
                                  context,
                                  boardSize,
                                  isTablet && boardHeader == null && boardFooter != null
                                      ? tabletBoardRadius
                                      : null,
                                ),
                                if (engineGaugeBuilder != null)
                                  SizedBox(height: boardSize, child: engineGaugeBuilder!(context)),
                              ],
                            ),
                            if (boardFooter != null)
                              Container(
                                // This key is used to preserve the state of the board footer when the pov changes
                                key: ValueKey(pov),
                                decoration: BoxDecoration(
                                  borderRadius: isTablet
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
                            if (pockets != null)
                              PocketsMenu(
                                side: pov,
                                sideToMove: sideToMove,
                                playerSide: playerSide,
                                pockets: pockets!,
                                squareSize: pocketSquareSize(
                                  boardSize: boardSize,
                                  isTablet: isTablet,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: isTablet
                              ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                              : EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorScheme.of(context).surfaceContainerLowest,
                            ),
                            child: _AnalysisTabView(
                              tabs: tabs,
                              controller: tabController,
                              children: children,
                            ),
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

class _AnalysisTabView extends StatelessWidget {
  const _AnalysisTabView({required this.tabs, required this.controller, required this.children});

  final List<AnalysisTab>? tabs;
  final TabController? controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const iconSize = 18.0;

    return Column(
      children: [
        if (tabs != null && tabs!.length > 1)
          Container(
            decoration: BoxDecoration(color: ColorScheme.of(context).surface),
            child: TabBar(
              controller: controller,
              tabs: tabs!
                  .map(
                    (tab) => Tab(
                      height: iconSize + 8.0,
                      icon: Icon(tab.icon, size: iconSize, semanticLabel: tab.l10n(context.l10n)),
                    ),
                  )
                  .toList(),
            ),
          ),
        Expanded(
          child: TabBarView(controller: controller, children: children),
        ),
      ],
    );
  }
}
