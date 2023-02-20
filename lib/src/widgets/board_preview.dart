import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';

class BoardPreview extends StatelessWidget {
  const BoardPreview({
    required this.boardData,
    this.boardSettings,
    this.errorMessage,
  });

  final BoardData boardData;
  final BoardSettings? boardSettings;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final aspectRatio = constrains.biggest.aspectRatio;
        final defaultBoardSize = constrains.biggest.shortestSide;
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

        return aspectRatio > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [boardOrError],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boardOrError,
                ],
              );
      },
    );
  }
}
