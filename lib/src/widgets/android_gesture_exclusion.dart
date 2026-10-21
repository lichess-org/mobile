import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:material_ui/material_ui.dart';

Future<bool>? _isSupportedFuture;
bool? _debugIsSupported;

/// Whether system gestures can be excluded: navigation gestures start with Android 10 (API 29).
Future<bool> _isGesturesExclusionSupported() => _debugIsSupported != null
    ? Future.value(_debugIsSupported)
    : _isSupportedFuture ??= _checkGesturesExclusionSupport();

/// Overrides whether system gestures can be excluded, or resets it to the device check if null.
@visibleForTesting
void debugSetGesturesExclusionSupported(bool? isSupported) {
  _debugIsSupported = isSupported;
}

Future<bool> _checkGesturesExclusionSupport() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return false;
  }
  try {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 29;
  } catch (_) {
    return false;
  }
}

/// A widget that sets immersive mode on android 10+ while [enabled] is true and the widget is
/// focused.
///
/// Android limits the exclusion of navigation gestures to 200dp of height per edge of the screen,
/// except in immersive mode, so the boards below this widget ([AndroidBoardGesturesExclusion])
/// exclude their whole edge columns while it is set.
///
/// This widget will keep the initial [MediaQueryData.viewPadding] whether immersive mode is set or
/// not. This works in conjunction with the [SafeArea.maintainBottomViewPadding] property. This is
/// the responsibility of the parent widget to set the [SafeArea] with the correct value.
class const AndroidImmersiveModeWidget({
  required final Widget child,

  /// Whether to set immersive mode, e.g. while a game is being played.
  required final bool enabled,
  super.key,
}) extends StatefulWidget {
  @override
  State<AndroidImmersiveModeWidget> createState() => _AndroidImmersiveModeWidgetState();
}

class _AndroidImmersiveModeWidgetState() extends State<AndroidImmersiveModeWidget> {
  EdgeInsets? initialViewPadding;

  bool _isSupported = false;
  bool _isFocused = false;
  bool _isImmersiveMode = false;

  @override
  void initState() {
    super.initState();
    _isGesturesExclusionSupported().then((supported) {
      if (supported && mounted) {
        setState(() {
          _isSupported = true;
          _updateImmersiveMode();
        });
      }
    });
  }

  @override
  void didUpdateWidget(AndroidImmersiveModeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateImmersiveMode();
  }

  @override
  void dispose() {
    if (_isImmersiveMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  /// Sets or removes immersive mode, depending on the current state.
  ///
  /// The boards below get the new state from the [_ImmersiveModeScope] when this widget is rebuilt.
  void _updateImmersiveMode() {
    final shouldSet = _isSupported && _isFocused && widget.enabled && !isTabletOrLarger(context);
    if (shouldSet == _isImmersiveMode) {
      return;
    }
    _isImmersiveMode = shouldSet;
    SystemChrome.setEnabledSystemUIMode(
      shouldSet ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  void _setFocused(bool isFocused) {
    if (!mounted) return;
    setState(() {
      _isFocused = isFocused;
      _updateImmersiveMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    initialViewPadding ??= MediaQuery.viewPaddingOf(context);

    return MediaQuery(
      // Always set the view padding to the initial value to avoid an UI shift when immersive mode
      // is enabled.
      data: MediaQuery.of(context).copyWith(viewPadding: initialViewPadding),
      child: FocusDetector(
        onFocusGained: () => _setFocused(true),
        onFocusLost: () => _setFocused(false),
        child: _ImmersiveModeScope(isImmersiveMode: _isImmersiveMode, child: widget.child),
      ),
    );
  }
}

class const _ImmersiveModeScope({required final bool isImmersiveMode, required super.child})
    extends InheritedWidget {
  @override
  bool updateShouldNotify(_ImmersiveModeScope oldWidget) =>
      isImmersiveMode != oldWidget.isImmersiveMode;
}

/// Excludes the system navigation gestures over an interactive board on android 10+, while the
/// board is visible.
///
/// Navigation gestures conflict with board gestures. Android limits their exclusion to 200dp of
/// height per edge of the screen, honored from the bottom up, which is about half of a phone board.
/// So this widget only excludes the edge squares that hold a piece the user can drag, since a
/// navigation gesture only starts from a touch on the edge. In immersive mode
/// ([AndroidImmersiveModeWidget]), which lifts the limit, it excludes the whole edge columns.
///
/// A board in a vertical scroll view doesn't exclude anything.
///
/// The excluded squares are updated whenever the board [controller] changes.
class const AndroidBoardGesturesExclusion({
  required final ChessboardController controller,
  required final Side orientation,
  required final double size,
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  @override
  State<AndroidBoardGesturesExclusion> createState() => _AndroidBoardGesturesExclusionState();
}

class _AndroidBoardGesturesExclusionState() extends State<AndroidBoardGesturesExclusion> {
  bool _isSupported = false;
  bool _isFocused = false;
  bool _isInScrollView = false;
  bool _isImmersiveMode = false;
  double _devicePixelRatio = 1.0;
  bool _isUpdateScheduled = false;

  bool get _isExcluding => _isSupported && _isFocused && !_isInScrollView;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scheduleUpdate);
    _isGesturesExclusionSupported().then((supported) {
      if (supported && mounted) {
        _isSupported = true;
        _scheduleUpdate();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isInScrollView = Scrollable.maybeOf(context, axis: Axis.vertical) != null;
    _isImmersiveMode =
        context.dependOnInheritedWidgetOfExactType<_ImmersiveModeScope>()?.isImmersiveMode ?? false;
    _devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    _scheduleUpdate();
  }

  @override
  void didUpdateWidget(AndroidBoardGesturesExclusion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_scheduleUpdate);
      widget.controller.addListener(_scheduleUpdate);
    }
    _scheduleUpdate();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scheduleUpdate);
    _boardsExcludedRects.remove(this);
    super.dispose();
  }

  void _setFocused(bool isFocused) {
    if (!mounted) return;
    _isFocused = isFocused;
    if (isFocused) {
      _scheduleUpdate();
    } else {
      _boardsExcludedRects.remove(this);
    }
  }

  /// Updates the rects after the next layout, once the board has its final position.
  void _scheduleUpdate() {
    if (_isUpdateScheduled) {
      return;
    }
    _isUpdateScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _isUpdateScheduled = false;
      _updateRects();
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _updateRects() {
    if (!mounted) {
      return;
    }
    final box = context.findRenderObject();
    if (!_isExcluding || box is! RenderBox || !box.hasSize) {
      _boardsExcludedRects.remove(this);
      return;
    }

    final origin = box.localToGlobal(Offset.zero);
    final squareSize = widget.size / 8;
    final rects = !widget.controller.interactive
        ? const <Rect>[]
        : _isImmersiveMode
        ? _edgeColumnRects(squareSize)
        : _draggableEdgeSquareRects(squareSize);
    _boardsExcludedRects.set(this, [
      for (final rect in rects)
        Rect.fromLTRB(
          (origin.dx + rect.left) * _devicePixelRatio,
          (origin.dy + rect.top) * _devicePixelRatio,
          (origin.dx + rect.right) * _devicePixelRatio,
          (origin.dy + rect.bottom) * _devicePixelRatio,
        ),
    ]);
  }

  /// The left and right columns of the board, from slightly above it.
  List<Rect> _edgeColumnRects(double squareSize) {
    const verticalThreshold = 10.0;
    return [
      Rect.fromLTWH(0, -verticalThreshold, squareSize, widget.size + verticalThreshold),
      Rect.fromLTWH(
        widget.size - squareSize,
        -verticalThreshold,
        squareSize,
        widget.size + verticalThreshold,
      ),
    ];
  }

  /// The squares of the left and right columns of the board that hold a piece the user can drag.
  List<Rect> _draggableEdgeSquareRects(double squareSize) {
    final playerSide = widget.controller.game.playerSide;
    bool isDraggable(Piece piece) => switch (playerSide) {
      PlayerSide.none => false,
      PlayerSide.both => true,
      PlayerSide.white => piece.color == Side.white,
      PlayerSide.black => piece.color == Side.black,
    };

    return [
      for (final MapEntry(key: square, value: piece) in widget.controller.pieces.entries)
        if (isDraggable(piece))
          if (_squareColumn(square) case final column when column == 0 || column == 7)
            Rect.fromLTWH(
              column * squareSize,
              _squareRow(square) * squareSize,
              squareSize,
              squareSize,
            ),
    ];
  }

  int _squareColumn(Square square) =>
      widget.orientation == Side.white ? square.file : 7 - square.file;

  int _squareRow(Square square) => widget.orientation == Side.white ? 7 - square.rank : square.rank;

  @override
  Widget build(BuildContext context) => FocusDetector(
    onFocusGained: () => _setFocused(true),
    onFocusLost: () => _setFocused(false),
    child: widget.child,
  );
}

/// The rects excluded by the visible boards.
final _boardsExcludedRects = _BoardsExcludedRects();

/// The rects excluded by the visible boards, in physical pixels.
///
/// The system keeps a single list of rects for the window, so this sends the rects of every board
/// together, and clears them once the last board is hidden or disposed.
class _BoardsExcludedRects() {
  final Map<Object, List<Rect>> _rectsByBoard = {};
  List<Rect> _sentRects = const [];

  void set(Object board, List<Rect> rects) {
    _rectsByBoard[board] = rects;
    _send();
  }

  void remove(Object board) {
    if (_rectsByBoard.remove(board) != null) {
      _send();
    }
  }

  void _send() {
    final rects = [for (final boardRects in _rectsByBoard.values) ...boardRects];
    if (listEquals(rects, _sentRects)) {
      return;
    }
    _sentRects = rects;
    _GesturesExclusion.instance.setRects(rects);
  }
}

class const _GesturesExclusion._() {
  static const _channel = MethodChannel('mobile.lichess.org/gestures_exclusion');

  static const instance = _GesturesExclusion._();

  Future<void> setRects(List<Rect> rects) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final rectsAsMaps = rects
        .where((r) => !r.hasNaN && !r.isInfinite) // Filter out bad rects first
        .map(
          (r) => {
            'left': r.left.floor(),
            'top': r.top.floor(),
            'right': r.right.floor(),
            'bottom': r.bottom.floor(),
          },
        )
        .toList();

    try {
      await _channel.invokeMethod<void>('setSystemGestureExclusionRects', rectsAsMaps);
    } on PlatformException catch (e) {
      debugPrint('Failed to set rects: ${e.message}');
    }
  }
}
