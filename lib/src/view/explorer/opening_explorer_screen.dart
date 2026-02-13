import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/game_analysis_board.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:share_plus/share_plus.dart';

class OpeningExplorerScreen extends ConsumerWidget {
  const OpeningExplorerScreen({required this.options});

  final AnalysisOptions options;

  static Route<dynamic> buildRoute(BuildContext context, AnalysisOptions options) {
    return buildScreenRoute(context, screen: OpeningExplorerScreen(options: options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final boardState = switch (ref.watch(ctrlProvider)) {
      AsyncData(value: final state) => state.currentPosition,
      _ => null,
    };

    final body = switch (ref.watch(ctrlProvider)) {
      AsyncData(value: final state) => _Body(options: options, state: state),
      AsyncError(:final error) => Center(
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text(error.toString())),
      ),
      _ => const CenterLoadingIndicator(),
    };
    return Scaffold(
      body: body,
      appBar: AppBar(
        title: Text(context.l10n.openingExplorer),
        actions: [
          if (boardState != null)
            SemanticIconButton(
              semanticsLabel: context.l10n.mobileSharePositionAsFEN,
              onPressed: () => launchShareDialog(context, ShareParams(text: boardState.fen)),
              icon: const PlatformShareIcon(),
            ),
        ],
        bottom: _MoveList(options: options),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.options, required this.state});

  final AnalysisOptions options;
  final AnalysisState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = isTabletOrLarger(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final orientation = constraints.maxWidth > constraints.maxHeight
                    ? Orientation.landscape
                    : Orientation.portrait;
                if (orientation == Orientation.landscape) {
                  final sideWidth =
                      constraints.biggest.longestSide - constraints.biggest.shortestSide;
                  final defaultBoardSize =
                      constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
                  final boardSize = sideWidth >= 250
                      ? defaultBoardSize
                      : constraints.biggest.longestSide / kGoldenRatio -
                            (kTabletBoardTableSidePadding * 2);
                  return Row(
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
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  final defaultBoardSize = constraints.biggest.shortestSide;
                  final remainingHeight = constraints.maxHeight - defaultBoardSize;
                  final isSmallScreen = remainingHeight < kSmallHeightMinusBoard;
                  final boardSize = isTablet || isSmallScreen
                      ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                      : defaultBoardSize;

                  return ListView(
                    padding: isTablet
                        ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                        : EdgeInsets.zero,
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
                      OpeningExplorerView(
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
                    ],
                  );
                }
              },
            ),
          ),
          _BottomBar(options: options),
        ],
      ),
    );
  }
}

class _MoveList extends ConsumerWidget implements PreferredSizeWidget {
  const _MoveList({required this.options});

  final AnalysisOptions options;

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

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.options});

  final AnalysisOptions options;

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
      children: [
        BottomBarButton(
          label: dbLabel,
          showLabel: true,
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            isDismissible: true,
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
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userPrevious();
}
