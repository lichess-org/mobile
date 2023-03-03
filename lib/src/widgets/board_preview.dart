import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:lichess_mobile/src/constants.dart';
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
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;

        final error = errorMessage != null
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: defaultTargetPlatform == TargetPlatform.iOS
                        ? CupertinoColors.secondarySystemBackground
                            .resolveFrom(context)
                        : Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(errorMessage!),
                  ),
                ),
              )
            : null;

        final board = Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: defaultTargetPlatform == TargetPlatform.iOS
                ? const BorderRadius.all(Radius.circular(10.0))
                : null,
          ),
          child: Board(
            size: boardSize,
            data: boardData,
            settings: BoardSettings(
              enableCoordinates: false,
              animationDuration: const Duration(milliseconds: 150),
              pieceAssets: pieceSet.assets,
              colorScheme: boardColor.colors,
            ),
          ),
        );

        return error != null
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
      },
    );
  }
}
