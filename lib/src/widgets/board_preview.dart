import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/settings/providers.dart';

class BoardPreview extends ConsumerWidget {
  const BoardPreview({
    required this.boardData,
    this.errorMessage,
  });

  final BoardData boardData;
  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardColor = ref.watch(boardThemePrefProvider);
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

        final board = Board(
          size: boardSize,
          data: boardData,
          settings: BoardSettings(
            enableCoordinates: false,
            animationDuration: const Duration(milliseconds: 150),
            pieceAssets: pieceSet.assets,
            colorScheme: boardColor.colors,
          ),
        );

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
