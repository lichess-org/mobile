import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'platform.dart';

const _scrollAnimationDuration = Duration(milliseconds: 200);
const _moveListOpacity = 0.6;

/// Board layout that adapts to screen size and aspect ratio.
///
/// On portrait mode, the board will be displayed in the middle of the screen,
/// with the table spaces on top and bottom.
/// On landscape mode, the board will be displayed on the left side of the screen,
/// with the table spaces on the right side.
///
/// An optional move list can be displayed above the top table space.
///
/// An optional overlay or error message can be displayed on top of the board.
class BoardTable extends ConsumerWidget {
  const BoardTable({
    required this.boardData,
    this.boardSettingsOverrides,
    required this.topTable,
    required this.bottomTable,
    this.engineGauge,
    this.moves,
    this.currentMoveIndex,
    this.onSelectMove,
    this.boardOverlay,
    this.errorMessage,
    this.showMoveListPlaceholder = false,
    super.key,
  }) : assert(
          moves == null || currentMoveIndex != null,
          'You must provide `currentMoveIndex` along with `moves`',
        );

  final BoardData boardData;

  final BoardSettingsOverrides? boardSettingsOverrides;

  /// Widget that will appear at the top of the board.
  final Widget topTable;

  /// Widget that will appear at the bottom of the board.
  final Widget bottomTable;

  /// Optional engine gauge that will be displayed next to the board.
  final EngineGaugeParams? engineGauge;

  /// Optional list of moves that will be displayed on top of the board.
  final List<String>? moves;

  /// Index of the current move in the [moves] list. Must be provided if [moves] is provided.
  final int? currentMoveIndex;

  /// Callback that will be called when a move is selected from the [moves] list.
  final void Function(int moveIndex)? onSelectMove;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  /// Optional widget that will be displayed on top of the board.
  final Widget? boardOverlay;

  /// Whether to show the move list placeholder. Useful when loading.
  final bool showMoveListPlaceholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.biggest.aspectRatio;
        final defaultBoardSize = constraints.biggest.shortestSide;

        final isTablet = defaultBoardSize > kTabletThreshold;
        final boardSize = isTablet
            ? defaultBoardSize - kTabletBoardTableSidePadding * 2
            : defaultBoardSize;

        final error = errorMessage != null
            ? SizedBox.square(
                dimension: boardSize,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoColors.secondarySystemBackground
                                .resolveFrom(context)
                            : Theme.of(context).colorScheme.background,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(errorMessage!),
                      ),
                    ),
                  ),
                ),
              )
            : null;

        final defaultSettings = BoardSettings(
          pieceAssets: boardPrefs.pieceSet.assets,
          colorScheme: boardPrefs.boardTheme.colors,
          showValidMoves: boardPrefs.showLegalMoves,
          showLastMove: boardPrefs.boardHighlights,
          enableCoordinates: boardPrefs.coordinates,
          animationDuration: boardPrefs.pieceAnimationDuration,
        );

        final settings = boardSettingsOverrides != null
            ? defaultSettings.copyWith(
                animationDuration: boardSettingsOverrides!.animationDuration,
              )
            : defaultSettings;

        final board =
            Board(size: boardSize, data: boardData, settings: settings);

        Widget boardWidget = board;

        if (boardOverlay != null) {
          boardWidget = SizedBox.square(
            dimension: boardSize,
            child: Stack(
              children: [
                board,
                SizedBox.square(
                  dimension: boardSize,
                  child: Center(
                    child: SizedBox(
                      width: (boardSize / 8) * 6.6,
                      height: (boardSize / 8) * 4.6,
                      child: boardOverlay,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (error != null) {
          boardWidget = SizedBox.square(
            dimension: boardSize,
            child: Stack(
              children: [
                board,
                error,
              ],
            ),
          );
        }

        final slicedMoves = moves?.asMap().entries.slices(2);

        return aspectRatio > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: kTabletBoardTableSidePadding,
                      top: kTabletBoardTableSidePadding,
                      bottom: kTabletBoardTableSidePadding,
                    ),
                    child: Row(
                      children: [
                        boardWidget,
                        if (engineGauge != null)
                          EngineGauge(
                            params: engineGauge!,
                            displayMode: EngineGaugeDisplayMode.vertical,
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(kTabletBoardTableSidePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(child: topTable),
                          if (slicedMoves != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MoveList(
                                  type: MoveListType.stacked,
                                  slicedMoves: slicedMoves,
                                  currentMoveIndex: currentMoveIndex ?? 0,
                                  onSelectMove: onSelectMove,
                                ),
                              ),
                            )
                          else
                            // same height as [MoveList]
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: SizedBox(height: 40),
                              ),
                            ),
                          Flexible(child: bottomTable),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (slicedMoves != null)
                    MoveList(
                      type: MoveListType.inline,
                      slicedMoves: slicedMoves,
                      currentMoveIndex: currentMoveIndex ?? 0,
                      onSelectMove: onSelectMove,
                    )
                  else if (showMoveListPlaceholder)
                    const SizedBox(height: 40),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            isTablet ? kTabletBoardTableSidePadding : 12.0,
                      ),
                      child: topTable,
                    ),
                  ),
                  if (engineGauge != null)
                    Padding(
                      padding: isTablet
                          ? const EdgeInsets.symmetric(
                              horizontal: kTabletBoardTableSidePadding,
                            )
                          : EdgeInsets.zero,
                      child: EngineGauge(
                        params: engineGauge!,
                        displayMode: EngineGaugeDisplayMode.horizontal,
                      ),
                    ),
                  boardWidget,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            isTablet ? kTabletBoardTableSidePadding : 12.0,
                      ),
                      child: bottomTable,
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class BoardSettingsOverrides {
  const BoardSettingsOverrides({
    this.animationDuration,
  });

  final Duration? animationDuration;
}

enum MoveListType { inline, stacked }

class MoveList extends StatefulWidget {
  const MoveList({
    required this.type,
    required this.slicedMoves,
    required this.currentMoveIndex,
    this.onSelectMove,
  });

  final MoveListType type;

  final Iterable<List<MapEntry<int, String>>> slicedMoves;

  final int currentMoveIndex;
  final void Function(int moveIndex)? onSelectMove;

  @override
  State<MoveList> createState() => _MoveListState();
}

class _MoveListState extends State<MoveList> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(const Duration(milliseconds: 100));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentMoveKey.currentContext != null) {
        Scrollable.ensureVisible(
          currentMoveKey.currentContext!,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MoveList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debounce(() {
      if (currentMoveKey.currentContext != null) {
        Scrollable.ensureVisible(
          currentMoveKey.currentContext!,
          alignment: 0.5,
          duration: _scrollAnimationDuration,
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == MoveListType.inline
        ? Container(
            padding: const EdgeInsets.only(left: 5),
            height: 40,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.slicedMoves
                    .mapIndexed(
                      (index, moves) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            InlineMoveCount(count: index + 1),
                            ...moves.map(
                              (move) {
                                // cursor index starts at 0, move index starts at 1
                                final isCurrentMove =
                                    widget.currentMoveIndex == move.key + 1;
                                return InlineMoveItem(
                                  key: isCurrentMove ? currentMoveKey : null,
                                  move: move,
                                  current: isCurrentMove,
                                  onSelectMove: widget.onSelectMove,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          )
        : PlatformCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: widget.slicedMoves
                      .mapIndexed(
                        (index, moves) => Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StackedMoveCount(count: index + 1),
                            Expanded(
                              child: Row(
                                children: [
                                  ...moves.map(
                                    (move) {
                                      // cursor index starts at 0, move index starts at 1
                                      final isCurrentMove =
                                          widget.currentMoveIndex ==
                                              move.key + 1;
                                      return Expanded(
                                        child: StackedMoveItem(
                                          key: isCurrentMove
                                              ? currentMoveKey
                                              : null,
                                          move: move,
                                          current: isCurrentMove,
                                          onSelectMove: widget.onSelectMove,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          );
  }
}

class InlineMoveCount extends StatelessWidget {
  const InlineMoveCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: Text(
        '$count.',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textShade(context, _moveListOpacity),
        ),
      ),
    );
  }
}

class InlineMoveItem extends StatelessWidget {
  const InlineMoveItem({
    required this.move,
    this.current,
    this.onSelectMove,
    super.key,
  });

  final MapEntry<int, String> move;
  final bool? current;
  final void Function(int moveIndex)? onSelectMove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectMove != null ? () => onSelectMove!(move.key + 1) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        decoration: ShapeDecoration(
          color: current == true
              ? defaultTargetPlatform == TargetPlatform.iOS
                  ? CupertinoDynamicColor.resolve(
                      CupertinoColors.secondarySystemBackground,
                      context,
                    )
                  : null
              // TODO add bg color on android
              : null,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        child: Text(
          move.value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color:
                current != true ? textShade(context, _moveListOpacity) : null,
          ),
        ),
      ),
    );
  }
}

class StackedMoveCount extends StatelessWidget {
  const StackedMoveCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(
        '$count.',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textShade(context, _moveListOpacity),
        ),
      ),
    );
  }
}

class StackedMoveItem extends StatelessWidget {
  const StackedMoveItem({
    required this.move,
    this.current,
    this.onSelectMove,
    super.key,
  });

  final MapEntry<int, String> move;
  final bool? current;
  final void Function(int moveIndex)? onSelectMove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectMove != null ? () => onSelectMove!(move.key + 1) : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          move.value,
          style: TextStyle(
            fontWeight: current == true ? FontWeight.bold : null,
            color: current != true ? textShade(context, 0.8) : null,
          ),
        ),
      ),
    );
  }
}

/// Returns the estimated height of spaces around the board.
double estimateTableHeight(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final safeHeight = size.height - padding.top - padding.bottom;
  // viewport height - board size - app bar height - bottom bar height
  return (safeHeight - size.width - 50 - 56) / 2;
}
