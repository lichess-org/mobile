import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

const _kBoardCarouselItemMargin = EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0);

class BoardCarouselItem extends ConsumerWidget {
  const BoardCarouselItem({super.key, 
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
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final brightness = Theme.of(context).colorScheme.brightness;

    final backgroundColor = lighten(
      boardPrefs.boardTheme.colors.darkSquare,
      brightness == Brightness.light ? 0.25 : 0.0,
    );

    final splashColor = lighten(
      boardPrefs.boardTheme.colors.darkSquare,
      brightness == Brightness.light ? 0.40 : 0.2,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide - _kBoardCarouselItemMargin.horizontal;
        final card = BrightnessHueFilter(
          hue: boardPrefs.hue,
          brightness: boardPrefs.brightness,
          child: PlatformCard(
            color: backgroundColor,
            margin:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? EdgeInsets.zero
                    : _kBoardCarouselItemMargin,
            child: AdaptiveInkWell(
              splashColor: splashColor,
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Stack(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.dstOut,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor.withValues(alpha: 0.25),
                          backgroundColor.withValues(alpha: 1.0),
                        ],
                        stops: const [0.3, 1.00],
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    child: SizedBox(
                      height: boardSize,
                      child: Chessboard.fixed(
                        size: boardSize,
                        fen: fen,
                        orientation: orientation,
                        lastMove: lastMove,
                        settings: ChessboardSettings(
                          enableCoordinates: false,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          pieceAssets: boardPrefs.pieceSet.assets,
                          colorScheme: boardPrefs.boardTheme.colors,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 8,
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: description,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        return Theme.of(context).platform == TargetPlatform.iOS
            ? Padding(
              padding: _kBoardCarouselItemMargin,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6.0),
                  ],
                ),
                child: card,
              ),
            )
            : card;
      },
    );
  }
}

const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

/// Like [PageView], but specialized for a list of boards.
///
/// The only difference is that the [BoardsPageView] doesn't have a [padEnds]
/// boolean property, and takes intead a [padding] property that allows to set
/// a specific padding for the viewport which is not dependent on the viewport
/// fraction.
class BoardsPageView extends StatefulWidget {
  BoardsPageView({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    List<Widget> children = const <Widget>[],
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padding = EdgeInsets.zero,
  }) : childrenDelegate = SliverChildListDelegate(children);

  BoardsPageView.builder({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    required NullableIndexedWidgetBuilder itemBuilder,
    ChildIndexGetter? findChildIndexCallback,
    int? itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padding = EdgeInsets.zero,
  }) : childrenDelegate = SliverChildBuilderDelegate(
         itemBuilder,
         findChildIndexCallback: findChildIndexCallback,
         childCount: itemCount,
       );

  final bool allowImplicitScrolling;
  final String? restorationId;
  final Axis scrollDirection;
  final bool reverse;
  final PageController? controller;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final ValueChanged<int>? onPageChanged;
  final SliverChildDelegate childrenDelegate;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final ScrollBehavior? scrollBehavior;
  final EdgeInsets padding;

  @override
  State<BoardsPageView> createState() => _BoardsPageViewState();
}

class _BoardsPageViewState extends State<BoardsPageView> {
  int _lastReportedPage = 0;

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
    _lastReportedPage = _controller.initialPage;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ?? PageController();
  }

  @override
  void didUpdateWidget(BoardsPageView oldWidget) {
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _initController();
    }
    super.didUpdateWidget(oldWidget);
  }

  AxisDirection _getDirection(BuildContext context) {
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        assert(debugCheckHasDirectionality(context));
        final TextDirection textDirection = Directionality.of(context);
        final AxisDirection axisDirection = textDirectionToAxisDirection(textDirection);
        return widget.reverse ? flipAxisDirection(axisDirection) : axisDirection;
      case Axis.vertical:
        return widget.reverse ? AxisDirection.up : AxisDirection.down;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AxisDirection axisDirection = _getDirection(context);
    final ScrollPhysics physics = _ForceImplicitScrollPhysics(
      allowImplicitScrolling: widget.allowImplicitScrolling,
    ).applyTo(
      widget.pageSnapping
          ? _kPagePhysics.applyTo(
            widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context),
          )
          : widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context),
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0 &&
            widget.onPageChanged != null &&
            notification is ScrollUpdateNotification) {
          final PageMetrics metrics = notification.metrics as PageMetrics;
          final int currentPage = metrics.page!.round();
          if (currentPage != _lastReportedPage) {
            _lastReportedPage = currentPage;
            widget.onPageChanged!(currentPage);
          }
        }
        return false;
      },
      child: Scrollable(
        dragStartBehavior: widget.dragStartBehavior,
        axisDirection: axisDirection,
        controller: _controller,
        physics: physics,
        restorationId: widget.restorationId,
        scrollBehavior:
            widget.scrollBehavior ?? ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Viewport(
            cacheExtent: 0,
            cacheExtentStyle: CacheExtentStyle.viewport,
            axisDirection: axisDirection,
            offset: position,
            clipBehavior: widget.clipBehavior,
            slivers: <Widget>[
              _SliverFillViewport(
                viewportFraction: _controller.viewportFraction,
                delegate: widget.childrenDelegate,
                padding: widget.padding,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SliverFillViewport extends StatelessWidget {
  const _SliverFillViewport({required this.delegate, this.viewportFraction = 1.0, this.padding})
    : assert(viewportFraction > 0.0);

  final double viewportFraction;

  final EdgeInsets? padding;

  final SliverChildDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: _SliverFillViewportRenderObjectWidget(
        viewportFraction: viewportFraction,
        delegate: delegate,
      ),
    );
  }
}

class _SliverFillViewportRenderObjectWidget extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportRenderObjectWidget({
    required super.delegate,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  final double viewportFraction;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverFillViewport(childManager: element, viewportFraction: viewportFraction);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _ForceImplicitScrollPhysics extends ScrollPhysics {
  const _ForceImplicitScrollPhysics({required this.allowImplicitScrolling, super.parent});

  @override
  _ForceImplicitScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ForceImplicitScrollPhysics(
      allowImplicitScrolling: allowImplicitScrolling,
      parent: buildParent(ancestor),
    );
  }

  @override
  final bool allowImplicitScrolling;
}
