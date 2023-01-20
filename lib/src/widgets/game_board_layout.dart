import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/style.dart';
import 'platform.dart';

/// Widget that provides a board layout for games according to screen constraints
///
/// This widget will try to adapt the board and players display according to screen
/// size constraints and aspect ratio.
class GameBoardLayout extends StatefulWidget {
  const GameBoardLayout({
    required this.boardData,
    this.boardSettings,
    required this.topPlayer,
    required this.bottomPlayer,
    this.moves,
    this.currentMoveIndex,
    this.onSelectMove,
    super.key,
  });

  final BoardData boardData;

  final BoardSettings? boardSettings;

  /// Player which should appear at the top of the board
  final Widget topPlayer;

  /// Player which should appear at the bottom of the board
  final Widget bottomPlayer;

  final List<String>? moves;

  final int? currentMoveIndex;

  final void Function(int moveIndex)? onSelectMove;

  @override
  State<GameBoardLayout> createState() => _GameBoardLayoutState();
}

class _GameBoardLayoutState extends State<GameBoardLayout> {
  final ScrollController scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant GameBoardLayout oldWidget) {
    // TODO should follow current move index instead
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final aspectRatio = constraints.biggest.aspectRatio;
      final defaultBoardSize = constraints.biggest.shortestSide;
      final double boardSize = aspectRatio < 1 && aspectRatio >= 0.84 ||
              aspectRatio > 1 && aspectRatio <= 1.18
          ? defaultBoardSize * 0.94
          : defaultBoardSize;

      final board = widget.boardSettings != null
          ? Board(
              size: boardSize,
              data: widget.boardData,
              settings: widget.boardSettings!)
          : Board(size: boardSize, data: widget.boardData);
      final List<List<MapEntry<int, String>>>? slicedMoves =
          widget.moves?.asMap().entries.slices(2).toList(growable: false);
      return aspectRatio > 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                board,
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.topPlayer,
                        if (slicedMoves != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PlatformCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: slicedMoves.length,
                                    itemBuilder: (_, index) => Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: slicedMoves[index]
                                          .map(
                                            (move) => Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(move.value),
                                              ),
                                            ),
                                          )
                                          .toList(growable: false),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        widget.bottomPlayer,
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
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    height: 40,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: slicedMoves.length,
                      itemBuilder: (_, index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            MoveCount(count: index + 1),
                            ...slicedMoves[index].map(
                              (move) => MoveItem(
                                move: move,
                                current: widget.currentMoveIndex == move.key,
                                onSelectMove: widget.onSelectMove,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                widget.topPlayer,
                board,
                widget.bottomPlayer,
              ],
            );
    });
  }
}

class MoveCount extends StatelessWidget {
  const MoveCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      child: Text(
        '$count.',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textShade(context, 0.7),
        ),
      ),
    );
  }
}

class MoveItem extends StatelessWidget {
  const MoveItem({required this.move, this.current, this.onSelectMove});

  final MapEntry<int, String> move;
  final bool? current;
  final void Function(int moveIndex)? onSelectMove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectMove != null ? () => onSelectMove!(move.key) : null,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        // color: current == true ? Colors.red : Colors.transparent,
        child: Text(
          move.value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: current != true ? textShade(context, 0.7) : null,
          ),
        ),
      ),
    );
  }
}
