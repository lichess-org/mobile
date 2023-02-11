import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/common/styles.dart';
import 'platform.dart';

const _scrollAnimationDuration = Duration(milliseconds: 200);
const _moveListOpacity = 0.6;

/// Widget that provides a board layout for games according to screen constraints
///
/// This widget will try to adapt the board and players display according to screen
/// size constraints and aspect ratio.
class GameBoardLayout extends StatelessWidget {
  const GameBoardLayout({
    required this.boardData,
    this.boardSettings,
    required this.topPlayer,
    required this.bottomPlayer,
    this.moves,
    this.currentMoveIndex,
    this.onSelectMove,
    this.errorMessage,
    super.key,
  }) : assert(
          moves == null || currentMoveIndex != null,
          'You must provide `currentMoveIndex` along with `moves`',
        );

  final BoardData boardData;

  final BoardSettings? boardSettings;

  /// Player which should appear at the top of the board
  final Widget topPlayer;

  /// Player which should appear at the bottom of the board
  final Widget bottomPlayer;

  final List<String>? moves;

  final int? currentMoveIndex;

  final void Function(int moveIndex)? onSelectMove;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.biggest.aspectRatio;
        final defaultBoardSize = constraints.biggest.shortestSide;
        final double boardSize = aspectRatio < 1 && aspectRatio >= 0.84 ||
                aspectRatio > 1 && aspectRatio <= 1.18
            ? defaultBoardSize * 0.94
            : defaultBoardSize;

        final error = errorMessage != null
            ? SizedBox.square(
                dimension: boardSize,
                child: Center(
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
              )
            : null;

        final board = boardSettings != null
            ? Board(size: boardSize, data: boardData, settings: boardSettings!)
            : Board(size: boardSize, data: boardData);

        final boardOrError = error != null
            ? SizedBox.square(
                dimension: boardSize,
                child: Stack(
                  children: [
                    board,
                    error,
                  ],
                ),
              )
            : board;

        final List<List<MapEntry<int, String>>>? slicedMoves =
            moves?.asMap().entries.slices(2).toList(growable: false);

        return aspectRatio > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  boardOrError,
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          topPlayer,
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
                          bottomPlayer,
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (slicedMoves != null)
                    MoveList(
                      type: MoveListType.inline,
                      slicedMoves: slicedMoves,
                      currentMoveIndex: currentMoveIndex ?? 0,
                      onSelectMove: onSelectMove,
                    ),
                  topPlayer,
                  boardOrError,
                  bottomPlayer,
                ],
              );
      },
    );
  }
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

  final List<List<MapEntry<int, String>>> slicedMoves;

  final int currentMoveIndex;
  final void Function(int moveIndex)? onSelectMove;

  @override
  State<MoveList> createState() => _MoveListState();
}

class _MoveListState extends State<MoveList> {
  final currentMoveKey = GlobalKey();

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
  void didUpdateWidget(covariant MoveList oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
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
                              (move) => InlineMoveItem(
                                key: widget.currentMoveIndex == move.key
                                    ? currentMoveKey
                                    : null,
                                move: move,
                                current: widget.currentMoveIndex == move.key,
                                onSelectMove: widget.onSelectMove,
                              ),
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
                                    (move) => Expanded(
                                      child: StackedMoveItem(
                                        key: widget.currentMoveIndex == move.key
                                            ? currentMoveKey
                                            : null,
                                        move: move,
                                        current:
                                            widget.currentMoveIndex == move.key,
                                        onSelectMove: widget.onSelectMove,
                                      ),
                                    ),
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
      onTap: onSelectMove != null ? () => onSelectMove!(move.key) : null,
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
      onTap: onSelectMove != null ? () => onSelectMove!(move.key) : null,
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
