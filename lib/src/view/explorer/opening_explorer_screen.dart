import 'package:collection/collection.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/view/analysis/game_analysis_board.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

class const OpeningExplorerScreen({required final AnalysisOptions options}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(AnalysisOptions options) {
    return buildScreenRoute(screen: OpeningExplorerScreen(options: options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    final body = switch (ref.watch(ctrlProvider)) {
      AsyncData(value: final state) => _Body(options: options, state: state),
      AsyncError(:final error) => Center(
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text(error.toString())),
      ),
      _ => const CenterLoadingIndicator(),
    };
    return WakelockWidget(
      child: PlatformScaffold(
        body: body,
        appBar: PlatformAppBar(
          title: Text(context.l10n.openingExplorer),
          actions: [
            ContextMenuIconButton(
              semanticsLabel: context.l10n.mobileShare,
              icon: const PlatformShareIcon(),
              actions: [
                ContextMenuAction(
                  label: context.l10n.mobileShareGamePGN,
                  onPressed: () {
                    Navigator.of(context).push(AnalysisShareScreen.buildRoute(options: options));
                  },
                ),
                ContextMenuAction(
                  label: context.l10n.mobileSharePositionAsFEN,
                  onPressed: () {
                    final analysisState = ref
                        .read(analysisControllerProvider(options))
                        .requireValue;
                    launchShareDialog(
                      context,
                      ShareParams(text: analysisState.currentPosition.fen),
                    );
                  },
                ),
              ],
            ),
          ],
          bottom: _MoveList(options: options),
        ),
      ),
    );
  }
}

class const _Body({required final AnalysisOptions options, required final AnalysisState state})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = isTabletOrLarger(context);
    // On iOS in portrait, the bottom bar floats over the content, which scrolls under it, like an
    // iOS toolbar.
    final floatingBar =
        Theme.of(context).platform == TargetPlatform.iOS &&
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final bottomBarInset = floatingBar
        ? kBottomBarHeight + MediaQuery.paddingOf(context).bottom
        : 0.0;

    // The body extends behind the app bar, so that the list scrolls under it in portrait (the app bar
    // is tinted once it is scrolled).
    final topInset = MediaQuery.paddingOf(context).top;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight - topInset);
        final orientation = size.width > size.height ? Orientation.landscape : Orientation.portrait;
        if (orientation == Orientation.landscape) {
          final sideWidth = size.longestSide - size.shortestSide;
          final defaultBoardSize = size.shortestSide - (kTabletBoardTableSidePadding * 2);
          final boardSize = sideWidth >= 250
              ? defaultBoardSize
              : size.longestSide / kGoldenRatio - (kTabletBoardTableSidePadding * 2);
          // Laid out below the app bar: nothing scrolls under it, the explorer list must not tint
          // it.
          final row = Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: kTabletBoardTableSidePadding,
                  top: kTabletBoardTableSidePadding,
                  bottom: kTabletBoardTableSidePadding,
                ),
                child: GameAnalysisBoard(
                  options: options,
                  boardSize: boardSize,
                  boardRadius: isTablet ? Styles.boardBorderRadius : null,
                  shouldReplaceChildOnUserMove: true,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.all(kTabletBoardTableSidePadding),
                        semanticContainer: false,
                        // Laid out below the app bar, and the bottom bar below takes care of the
                        // bottom inset.
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: OpeningExplorerView(
                            pov: options.orientation,
                            position: state.currentPosition,
                            opening: state.currentNode.isRoot
                                ? LightOpening(eco: '', name: context.l10n.startPosition)
                                : state.currentNode.opening ?? state.currentBranchOpening,
                            onMoveSelected: (move) {
                              ref
                                  .read(analysisControllerProvider(options).notifier)
                                  .onUserMove(move);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          return Padding(
            padding: EdgeInsets.only(top: topInset),
            child: NotificationListener<ScrollNotification>(
              onNotification: (_) => true,
              child: NotificationListener<ScrollMetricsNotification>(
                onNotification: (_) => true,
                child: row,
              ),
            ),
          );
        } else {
          final defaultBoardSize = size.shortestSide;
          final remainingHeight = size.height - bottomBarInset - defaultBoardSize;
          final isSmallScreen = remainingHeight < kSmallHeightMinusBoard;
          final boardSize = isTablet || isSmallScreen
              ? defaultBoardSize - kTabletBoardTableSidePadding * 2
              : defaultBoardSize;

          final sidePadding = isTablet ? kTabletBoardTableSidePadding : 0.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(sidePadding, topInset, sidePadding, bottomBarInset),
            children: [
              Center(
                child: GestureDetector(
                  // disable scrolling when dragging the board
                  onVerticalDragStart: (_) {},
                  child: GameAnalysisBoard(
                    options: options,
                    boardSize: boardSize,
                    shouldReplaceChildOnUserMove: true,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: remainingHeight),
                child: OpeningExplorerView(
                  pov: options.orientation,
                  position: state.currentPosition,
                  opening: state.currentNode.isRoot
                      ? LightOpening(eco: '', name: context.l10n.startPosition)
                      : state.currentNode.opening ?? state.currentBranchOpening,
                  onMoveSelected: (move) {
                    ref.read(analysisControllerProvider(options).notifier).onUserMove(move);
                  },
                  scrollable: false,
                ),
              ),
            ],
          );
        }
      },
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: floatingBar
          ? Stack(
              children: [
                Positioned.fill(
                  child: BottomBarScrollEdgeEffect(
                    barHeight: bottomBarInset,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: content,
                  ),
                ),
                Positioned(left: 0, right: 0, bottom: 0, child: _BottomBar(options: options)),
              ],
            )
          : Column(
              children: [
                Expanded(child: content),
                _BottomBar(options: options),
              ],
            ),
    );
  }
}

class const _MoveList({required final AnalysisOptions options})
    extends ConsumerWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(40.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    switch (ref.watch(ctrlProvider)) {
      case AsyncData(value: final state):
        final slicedMoves = state.root.mainline
            .map((e) => e.sanMove.san)
            .toList()
            .asMap()
            .entries
            .slices(2);
        final currentMoveIndex = state.currentNode.position.ply;

        return MoveList(
          type: MoveListType.inline,
          slicedMoves: slicedMoves,
          currentMoveIndex: currentMoveIndex,
          onSelectMove: (index) {
            ref.read(ctrlProvider.notifier).jumpToNthNodeOnMainline(index - 1);
          },
        );
      case _:
        return const SizedBox.shrink();
    }
  }
}

class const _BottomBar({required final AnalysisOptions options}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(openingExplorerPreferencesProvider.select((value) => value.db));
    final ctrlProvider = analysisControllerProvider(options);
    final canGoBack = ref.watch(ctrlProvider.select((value) => value.requireValue.canGoBack));
    final canGoNext = ref.watch(ctrlProvider.select((value) => value.requireValue.canGoNext));

    final dbLabel = switch (db) {
      OpeningDatabase.master => 'Masters',
      OpeningDatabase.lichess => 'Lichess',
      OpeningDatabase.player => context.l10n.player,
    };

    return BottomBar(
      cupertinoGlass: true,
      children: [
        BottomBarButton(
          label: dbLabel,
          showLabel: true,
          onTap: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => const OpeningExplorerSettings(),
          ),
          icon: Icons.tune,
        ),
        BottomBarButton(
          label: 'Flip',
          tooltip: context.l10n.flipBoard,
          showLabel: true,
          onTap: () => ref.read(ctrlProvider.notifier).toggleBoard(),
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        BottomBarGroup(
          children: [
            RepeatButton(
              onLongPress: canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap: canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                showLabel: true,
                icon: CupertinoIcons.chevron_back,
                showTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress: canGoNext ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                icon: CupertinoIcons.chevron_forward,
                label: 'Next',
                showLabel: true,
                onTap: canGoNext ? () => _moveForward(ref) : null,
                showTooltip: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userPrevious();
}
