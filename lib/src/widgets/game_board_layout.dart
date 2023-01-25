import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/style.dart';
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
    super.key,
  }) : assert(moves == null || currentMoveIndex != null,
            'You must provide `currentMoveIndex` along with `moves`');

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
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final aspectRatio = constraints.biggest.aspectRatio;
      final defaultBoardSize = constraints.biggest.shortestSide;
      final double boardSize = aspectRatio < 1 && aspectRatio >= 0.84 ||
              aspectRatio > 1 && aspectRatio <= 1.18
          ? defaultBoardSize * 0.94
          : defaultBoardSize;

      final board = boardSettings != null
          ? Board(size: boardSize, data: boardData, settings: boardSettings!)
          : Board(size: boardSize, data: boardData);
      final List<List<MapEntry<int, String>>>? slicedMoves =
          moves?.asMap().entries.slices(2).toList(growable: false);
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
                        topPlayer,
                        if (slicedMoves != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: StackedMoveList(
                                slicedMoves: slicedMoves,
                                currentMoveIndex: currentMoveIndex ?? 0,
                                onSelectMove: onSelectMove,
                              ),
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
                  InlineMoveList(
                    slicedMoves: slicedMoves,
                    currentMoveIndex: currentMoveIndex ?? 0,
                    onSelectMove: onSelectMove,
                  ),
                topPlayer,
                board,
                bottomPlayer,
              ],
            );
    });
  }
}

class InlineMoveList extends StatefulWidget {
  const InlineMoveList(
      {required this.slicedMoves,
      required this.currentMoveIndex,
      this.onSelectMove});

  final List<List<MapEntry<int, String>>> slicedMoves;

  final int currentMoveIndex;
  final void Function(int moveIndex)? onSelectMove;

  @override
  State<InlineMoveList> createState() => _InlineMoveListState();
}

class _InlineMoveListState extends State<InlineMoveList> {
  final ScrollController scrollController = ScrollController();
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
  void didUpdateWidget(covariant InlineMoveList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (scrollController.hasClients) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 40,
      child: ListView.builder(
        // hack to allow ensureVisible working
        // TODO work on a different solution
        cacheExtent: 5000,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.slicedMoves.length,
        itemBuilder: (_, index) => Container(
          margin: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              InlineMoveCount(count: index + 1),
              ...widget.slicedMoves[index].map(
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
                      CupertinoColors.secondarySystemBackground, context)
                  : null
              // TODO add bg color on android
              : null,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
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

class StackedMoveList extends StatefulWidget {
  const StackedMoveList(
      {required this.slicedMoves,
      required this.currentMoveIndex,
      this.onSelectMove});

  final List<List<MapEntry<int, String>>> slicedMoves;

  final int currentMoveIndex;
  final void Function(int moveIndex)? onSelectMove;

  @override
  State<StackedMoveList> createState() => _StackedMoveListState();
}

class _StackedMoveListState extends State<StackedMoveList> {
  final ScrollController scrollController = ScrollController();
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
  void didUpdateWidget(covariant StackedMoveList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (scrollController.hasClients) {
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
  }

  @override
  Widget build(BuildContext context) {
    return PlatformCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          // hack to allow ensureVisible working
          // TODO work on a different solution
          cacheExtent: 5000,
          controller: scrollController,
          itemCount: widget.slicedMoves.length,
          itemBuilder: (_, index) => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StackedMoveCount(count: index + 1),
              Expanded(
                child: Row(
                  children: [
                    ...widget.slicedMoves[index].map(
                      (move) => Expanded(
                        child: StackedMoveItem(
                          key: widget.currentMoveIndex == move.key
                              ? currentMoveKey
                              : null,
                          move: move,
                          current: widget.currentMoveIndex == move.key,
                          onSelectMove: widget.onSelectMove,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
