import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

class SmallBoardPreview extends ConsumerStatefulWidget {
  const SmallBoardPreview({
    required this.orientation,
    required this.fen,
    required this.description,
    this.lastMove,
    this.onTap,
  });

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  final Widget description;

  final GestureTapCallback? onTap;

  @override
  ConsumerState<SmallBoardPreview> createState() => _SmallBoardPreviewState();
}

class _SmallBoardPreviewState extends ConsumerState<SmallBoardPreview> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide * 0.40;
        return Container(
          decoration: BoxDecoration(
            color: _isPressed
                ? CupertinoDynamicColor.resolve(
                    CupertinoColors.systemGrey5,
                    context,
                  )
                : null,
          ),
          child: Padding(
            padding: Styles.bodySectionPadding,
            child: SizedBox(
              height: boardSize,
              child: Row(
                children: [
                  Board(
                    size: boardSize,
                    data: BoardData(
                      interactableSide: InteractableSide.none,
                      fen: widget.fen,
                      orientation: widget.orientation,
                      lastMove: widget.lastMove,
                    ),
                    settings: BoardSettings(
                      enableCoordinates: false,
                      animationDuration: const Duration(milliseconds: 150),
                      pieceAssets: boardPrefs.pieceSet.assets,
                      colorScheme: boardPrefs.boardTheme.colors,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(child: widget.description),
                ],
              ),
            ),
          ),
        );
      },
    );

    return widget.onTap != null
        ? defaultTargetPlatform == TargetPlatform.iOS
            ? GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: widget.onTap,
                child: content,
              )
            : InkWell(
                onTap: widget.onTap,
                child: content,
              )
        : content;
  }
}

/// A simple board preview widget that is not interactable.
class BoardPreview extends ConsumerStatefulWidget {
  const BoardPreview({
    required this.orientation,
    required this.fen,
    this.header,
    this.footer,
    this.margin,
    this.lastMove,
    this.errorMessage,
    this.onTap,
  });

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  /// An optional error message to display over the board.
  final String? errorMessage;

  /// Show a header above the board. Typically a [Text] widget.
  final Widget? header;

  /// Show a footer below the board. Typically a [Text] widget.
  final Widget? footer;

  final EdgeInsetsGeometry? margin;

  final GestureTapCallback? onTap;

  @override
  _BoardPreviewState createState() => _BoardPreviewState();
}

class _BoardPreviewState extends ConsumerState<BoardPreview> {
  double scale = 1.0;

  void _onTapDown() {
    if (widget.onTap == null) return;
    setState(() => scale = 0.98);
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    setState(() => scale = 1.00);
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final board = LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;

        final error = widget.errorMessage != null
            ? Center(
                // ignore: avoid-wrapping-in-padding
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      child: Text(widget.errorMessage!),
                    ),
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
            data: BoardData(
              interactableSide: InteractableSide.none,
              fen: widget.fen,
              orientation: widget.orientation,
              lastMove: widget.lastMove,
            ),
            settings: BoardSettings(
              enableCoordinates: false,
              animationDuration: const Duration(milliseconds: 150),
              pieceAssets: boardPrefs.pieceSet.assets,
              colorScheme: boardPrefs.boardTheme.colors,
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

    final maybeTappableBoard = widget.onTap != null
        ? GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _onTapDown(),
            onTapCancel: _onTapCancel,
            onTapUp: (_) => _onTapCancel(),
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 100),
              child: board,
            ),
          )
        : board;

    final headerWidget = widget.header != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: defaultTargetPlatform == TargetPlatform.android
                ? DefaultTextStyle.merge(
                    style: Styles.sectionTitle,
                    child: widget.header!,
                  )
                : DefaultTextStyle(
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .merge(Styles.sectionTitle),
                    child: widget.header!,
                  ),
          )
        : null;

    return Padding(
      padding: widget.margin ?? Styles.bodySectionPadding,
      child: headerWidget != null || widget.footer != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (headerWidget != null) headerWidget,
                maybeTappableBoard,
                if (widget.footer != null) widget.footer!,
              ],
            )
          : maybeTappableBoard,
    );
  }
}
