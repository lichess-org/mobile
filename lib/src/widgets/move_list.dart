import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

const _scrollAnimationDuration = Duration(milliseconds: 200);
const _moveListOpacity = 0.8;

const _kMoveListHeight = 40.0;

enum MoveListType { inline, stacked }

class MoveList extends ConsumerStatefulWidget {
  const MoveList({
    required this.type,
    required this.slicedMoves,
    required this.currentMoveIndex,
    this.inlineColor,
    this.inlineDecoration,
    this.onSelectMove,
  });

  final MoveListType type;

  final Color? inlineColor;

  final BoxDecoration? inlineDecoration;

  final Iterable<List<MapEntry<int, String>>> slicedMoves;

  final int currentMoveIndex;
  final void Function(int moveIndex)? onSelectMove;

  @override
  ConsumerState<MoveList> createState() => _MoveListState();
}

class _MoveListState extends ConsumerState<MoveList> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(const Duration(milliseconds: 100));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentMoveKey.currentContext != null) {
        Scrollable.ensureVisible(currentMoveKey.currentContext!, alignment: 0.5);
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
    final pieceNotation = ref
        .watch(pieceNotationProvider)
        .maybeWhen(data: (value) => value, orElse: () => defaultAccountPreferences.pieceNotation);

    return widget.type == MoveListType.inline
        ? Container(
          decoration: widget.inlineDecoration,
          padding: const EdgeInsets.only(left: 5),
          height: _kMoveListHeight,
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
                          InlineMoveCount(
                            pieceNotation: pieceNotation,
                            count: index + 1,
                            color: widget.inlineColor,
                          ),
                          ...moves.map((move) {
                            // cursor index starts at 0, move index starts at 1
                            final isCurrentMove = widget.currentMoveIndex == move.key + 1;
                            return InlineMoveItem(
                              key: isCurrentMove ? currentMoveKey : null,
                              move: move,
                              color: widget.inlineColor,
                              pieceNotation: pieceNotation,
                              current: isCurrentMove,
                              onSelectMove: widget.onSelectMove,
                            );
                          }),
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
                                ...moves.map((move) {
                                  // cursor index starts at 0, move index starts at 1
                                  final isCurrentMove = widget.currentMoveIndex == move.key + 1;
                                  return Expanded(
                                    child: StackedMoveItem(
                                      key: isCurrentMove ? currentMoveKey : null,
                                      move: move,
                                      current: isCurrentMove,
                                      onSelectMove: widget.onSelectMove,
                                    ),
                                  );
                                }),
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
  const InlineMoveCount({required this.count, required this.pieceNotation, this.color});

  final PieceNotation pieceNotation;
  final int count;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: Text(
        '$count.',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color?.withValues(alpha: _moveListOpacity) ?? textShade(context, _moveListOpacity),
          fontFamily: pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
        ),
      ),
    );
  }
}

class InlineMoveItem extends StatelessWidget {
  const InlineMoveItem({
    required this.move,
    required this.pieceNotation,
    this.color,
    this.current,
    this.onSelectMove,
    super.key,
  });

  final Color? color;

  final MapEntry<int, String> move;
  final PieceNotation pieceNotation;
  final bool? current;
  final void Function(int moveIndex)? onSelectMove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectMove != null ? () => onSelectMove!(move.key + 1) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        child: Text(
          move.value,
          style: TextStyle(
            fontFamily: pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
            fontWeight: current == true ? FontWeight.bold : FontWeight.w500,
            color:
                current != true
                    ? color != null
                        ? color!.withValues(alpha: _moveListOpacity)
                        : textShade(context, _moveListOpacity)
                    : ColorScheme.of(context).primary,
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
      width: 40.0,
      child: Text(
        '$count.',
        style: TextStyle(fontWeight: FontWeight.w600, color: textShade(context, _moveListOpacity)),
      ),
    );
  }
}

class StackedMoveItem extends StatelessWidget {
  const StackedMoveItem({required this.move, this.current, this.onSelectMove, super.key});

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
