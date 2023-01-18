import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';

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

  @override
  State<GameBoardLayout> createState() => _GameBoardLayoutState();
}

class _GameBoardLayoutState extends State<GameBoardLayout> {
  final ScrollController scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant GameBoardLayout oldWidget) {
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
      final List<List<String>>? slicedMoves =
          widget.moves?.slices(2).toList(growable: false);
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
                                                child: Text(move),
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
                if (widget.moves != null)
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    height: 40,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.moves!.length,
                      itemBuilder: (_, index) => Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(widget.moves![index]),
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
