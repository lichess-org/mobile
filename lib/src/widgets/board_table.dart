import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';

import 'platform.dart';

const _scrollAnimationDuration = Duration(milliseconds: 200);
const _moveListOpacity = 0.6;

/// Board layout that adapts to screen size and aspect ratio.
///
/// On portrait mode, the board will be displayed in the middle of the screen,
/// with the table spaces on top and bottom.
/// On landscape mode, the board will be displayed on the left side of the screen,
/// with the table spaces on the right side.
///
/// An optional move list can be displayed above the top table space.
///
/// An optional overlay or error message can be displayed on top of the board.
class BoardTable extends ConsumerStatefulWidget {
  const BoardTable({
    this.onMove,
    this.onPremove,
    required this.boardState,
    this.boardSettingsOverrides,
    required this.topTable,
    required this.bottomTable,
    this.engineGauge,
    this.moves,
    this.currentMoveIndex,
    this.onSelectMove,
    this.boardOverlay,
    this.errorMessage,
    this.showMoveListPlaceholder = false,
    this.showEngineGaugePlaceholder = false,
    this.boardKey,
    this.zenMode = false,
    super.key,
  }) : assert(
          moves == null || currentMoveIndex != null,
          'You must provide `currentMoveIndex` along with `moves`',
        );

  final void Function(Move, {bool? isDrop, bool? isPremove})? onMove;
  final void Function(Move?)? onPremove;

  final ChessboardState boardState;

  final BoardSettingsOverrides? boardSettingsOverrides;

  /// [GlobalKey] for the board.
  ///
  /// Used to set gestures exclusion on android.
  final GlobalKey? boardKey;

  /// Widget that will appear at the top of the board.
  final Widget topTable;

  /// Widget that will appear at the bottom of the board.
  final Widget bottomTable;

  /// Optional engine gauge that will be displayed next to the board.
  final EngineGaugeParams? engineGauge;

  /// Optional list of moves that will be displayed on top of the board.
  final List<String>? moves;

  /// Index of the current move in the [moves] list. Must be provided if [moves] is provided.
  final int? currentMoveIndex;

  /// Callback that will be called when a move is selected from the [moves] list.
  final void Function(int moveIndex)? onSelectMove;

  /// Optional error message that will be displayed on top of the board.
  final String? errorMessage;

  /// Optional widget that will be displayed on top of the board.
  final Widget? boardOverlay;

  /// Whether to show the move list placeholder. Useful when loading.
  final bool showMoveListPlaceholder;

  /// Whether to show the engine gauge placeholder.
  final bool showEngineGaugePlaceholder;

  /// If true, the move list will be hidden
  final bool zenMode;

  @override
  ConsumerState<BoardTable> createState() => _BoardTableState();
}

class _BoardTableState extends ConsumerState<BoardTable> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.biggest.aspectRatio;
        final defaultBoardSize = constraints.biggest.shortestSide;
        final isTablet = isTabletOrLarger(context);
        final boardSize = isTablet
            ? defaultBoardSize - kTabletBoardTableSidePadding * 2
            : defaultBoardSize;

        // vertical space left on portrait mode to check if we can display the
        // move list
        final verticalSpaceLeftBoardOnPortrait =
            constraints.biggest.height - boardSize;

        final error = widget.errorMessage != null
            ? SizedBox.square(
                dimension: boardSize,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).platform == TargetPlatform.iOS
                            ? CupertinoColors.secondarySystemBackground
                                .resolveFrom(context)
                            : Theme.of(context).colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.errorMessage!),
                      ),
                    ),
                  ),
                ),
              )
            : null;

        final defaultSettings = ChessboardSettings(
          pieceAssets: boardPrefs.pieceSet.assets,
          colorScheme: boardPrefs.boardTheme.colors,
          showValidMoves: boardPrefs.showLegalMoves,
          showLastMove: boardPrefs.boardHighlights,
          enableCoordinates: boardPrefs.coordinates,
          animationDuration: boardPrefs.pieceAnimationDuration,
          borderRadius: isTablet
              ? const BorderRadius.all(Radius.circular(4.0))
              : BorderRadius.zero,
          boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
          drawShape: DrawShapeOptions(
            enable: boardPrefs.enableShapeDrawings,
            onCompleteShape: _onCompleteShape,
            onClearShapes: _onClearShapes,
          ),
          pieceShiftMethod: boardPrefs.pieceShiftMethod,
        );

        final settings = widget.boardSettingsOverrides != null
            ? widget.boardSettingsOverrides!.merge(defaultSettings)
            : defaultSettings;

        final board = Chessboard(
          key: widget.boardKey,
          size: boardSize,
          state: widget.boardState.copyWith(
            shapes: userShapes.union(widget.boardState.shapes ?? ISet()),
          ),
          settings: settings,
          onMove: widget.onMove,
          onPremove: widget.onPremove,
        );

        Widget boardWidget = board;

        if (widget.boardOverlay != null) {
          boardWidget = SizedBox.square(
            dimension: boardSize,
            child: Stack(
              children: [
                board,
                SizedBox.square(
                  dimension: boardSize,
                  child: Center(
                    child: SizedBox(
                      width: (boardSize / 8) * 6.6,
                      height: (boardSize / 8) * 4.6,
                      child: widget.boardOverlay,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (error != null) {
          boardWidget = SizedBox.square(
            dimension: boardSize,
            child: Stack(
              children: [
                board,
                error,
              ],
            ),
          );
        }

        final slicedMoves = widget.moves?.asMap().entries.slices(2);

        return aspectRatio > 1
            ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: kTabletBoardTableSidePadding,
                      top: kTabletBoardTableSidePadding,
                      bottom: kTabletBoardTableSidePadding,
                    ),
                    child: Row(
                      children: [
                        boardWidget,
                        if (widget.engineGauge != null)
                          EngineGauge(
                            params: widget.engineGauge!,
                            displayMode: EngineGaugeDisplayMode.vertical,
                          )
                        else if (widget.showEngineGaugePlaceholder)
                          const SizedBox(width: kEvalGaugeSize),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(kTabletBoardTableSidePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(child: widget.topTable),
                          if (!widget.zenMode && slicedMoves != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MoveList(
                                  type: MoveListType.stacked,
                                  slicedMoves: slicedMoves,
                                  currentMoveIndex:
                                      widget.currentMoveIndex ?? 0,
                                  onSelectMove: widget.onSelectMove,
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
                          Flexible(child: widget.bottomTable),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!widget.zenMode &&
                      slicedMoves != null &&
                      verticalSpaceLeftBoardOnPortrait >= 130)
                    MoveList(
                      type: MoveListType.inline,
                      slicedMoves: slicedMoves,
                      currentMoveIndex: widget.currentMoveIndex ?? 0,
                      onSelectMove: widget.onSelectMove,
                    )
                  else if (widget.showMoveListPlaceholder &&
                      verticalSpaceLeftBoardOnPortrait >= 130)
                    const SizedBox(height: 40),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            isTablet ? kTabletBoardTableSidePadding : 12.0,
                      ),
                      child: widget.topTable,
                    ),
                  ),
                  if (widget.engineGauge != null)
                    Padding(
                      padding: isTablet
                          ? const EdgeInsets.symmetric(
                              horizontal: kTabletBoardTableSidePadding,
                            )
                          : EdgeInsets.zero,
                      child: EngineGauge(
                        params: widget.engineGauge!,
                        displayMode: EngineGaugeDisplayMode.horizontal,
                      ),
                    )
                  else if (widget.showEngineGaugePlaceholder)
                    const SizedBox(height: kEvalGaugeSize),
                  boardWidget,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            isTablet ? kTabletBoardTableSidePadding : 12.0,
                      ),
                      child: widget.bottomTable,
                    ),
                  ),
                ],
              );
      },
    );
  }

  void _onCompleteShape(Shape shape) {
    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }
}

class BoardSettingsOverrides {
  const BoardSettingsOverrides({
    this.animationDuration,
    this.autoQueenPromotion,
    this.autoQueenPromotionOnPremove,
    this.blindfoldMode,
  });

  final Duration? animationDuration;
  final bool? autoQueenPromotion;
  final bool? autoQueenPromotionOnPremove;
  final bool? blindfoldMode;

  ChessboardSettings merge(ChessboardSettings settings) {
    return settings.copyWith(
      animationDuration: animationDuration,
      autoQueenPromotion: autoQueenPromotion,
      autoQueenPromotionOnPremove: autoQueenPromotionOnPremove,
      blindfoldMode: blindfoldMode,
    );
  }
}

enum MoveListType { inline, stacked }

class MoveList extends ConsumerStatefulWidget {
  const MoveList({
    required this.type,
    required this.slicedMoves,
    required this.currentMoveIndex,
    this.onSelectMove,
  });

  final MoveListType type;

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
        Scrollable.ensureVisible(
          currentMoveKey.currentContext!,
          alignment: 0.5,
        );
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
    final pieceNotation = ref.watch(pieceNotationProvider).maybeWhen(
          data: (value) => value,
          orElse: () => defaultAccountPreferences.pieceNotation,
        );

    return widget.type == MoveListType.inline
        ? Container(
            padding: const EdgeInsets.only(left: 5),
            height: 40,
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
                            InlineMoveCount(count: index + 1),
                            ...moves.map(
                              (move) {
                                // cursor index starts at 0, move index starts at 1
                                final isCurrentMove =
                                    widget.currentMoveIndex == move.key + 1;
                                return InlineMoveItem(
                                  key: isCurrentMove ? currentMoveKey : null,
                                  move: move,
                                  pieceNotation: pieceNotation,
                                  current: isCurrentMove,
                                  onSelectMove: widget.onSelectMove,
                                );
                              },
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
                                    (move) {
                                      // cursor index starts at 0, move index starts at 1
                                      final isCurrentMove =
                                          widget.currentMoveIndex ==
                                              move.key + 1;
                                      return Expanded(
                                        child: StackedMoveItem(
                                          key: isCurrentMove
                                              ? currentMoveKey
                                              : null,
                                          move: move,
                                          current: isCurrentMove,
                                          onSelectMove: widget.onSelectMove,
                                        ),
                                      );
                                    },
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
    required this.pieceNotation,
    this.current,
    this.onSelectMove,
    super.key,
  });

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
        decoration: ShapeDecoration(
          color: current == true
              ? Theme.of(context).platform == TargetPlatform.iOS
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
            fontFamily:
                pieceNotation == PieceNotation.symbol ? 'ChessFont' : null,
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
