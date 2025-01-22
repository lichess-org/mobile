import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    required this.size,
    required this.boardPrefs,
    required this.fen,
    required this.orientation,
    required this.gameData,
    required this.lastMove,
    required this.shapes,
    required this.settings,
    required this.boardOverlay,
    required this.error,
    this.boardKey,
  });

  final double size;
  final BoardPrefs boardPrefs;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ISet<Shape> shapes;
  final ChessboardSettings settings;
  final String? error;
  final Widget? boardOverlay;
  final GlobalKey? boardKey;

  @override
  Widget build(BuildContext context) {
    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: gameData,
      lastMove: lastMove,
      shapes: shapes,
      settings: settings,
    );

    if (boardOverlay != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            board,
            SizedBox.square(
              dimension: size,
              child: Center(
                child: SizedBox(
                  width: (size / 8) * 6.6,
                  height: (size / 8) * 4.6,
                  child: boardOverlay,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (error != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(children: [board, _ErrorWidget(errorMessage: error!, boardSize: size)]),
      );
    }

    return board;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage, required this.boardSize});
  final double boardSize;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: boardSize,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoColors.secondarySystemBackground.resolveFrom(context)
                      : Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(padding: const EdgeInsets.all(10.0), child: Text(errorMessage)),
          ),
        ),
      ),
    );
  }
}
