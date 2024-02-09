import 'package:chessground/chessground.dart';
import 'package:flutter/widgets.dart';

/// Wrapper around [Board] that handles gestures exclusions on android.
class PlayableBoard extends StatelessWidget {
  const PlayableBoard({
    super.key,
    required this.size,
    required this.data,
    this.settings = const BoardSettings(),
    this.onMove,
    this.onPremove,
  });

  /// Visal size of the board
  final double size;

  /// Settings that control the theme, behavior and purpose of the board.
  final BoardSettings settings;

  /// Data that represents the current state of the board
  final BoardData data;

  /// Callback called after a move has been made.
  final void Function(Move, {bool? isDrop, bool? isPremove})? onMove;

  /// Callback called after a premove has been set/unset.
  ///
  /// If the callback is null, the board will not allow premoves.
  final void Function(Move?)? onPremove;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
