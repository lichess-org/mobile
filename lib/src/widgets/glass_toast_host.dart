import 'dart:async';

import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassToast, GlassToastPosition, GlassToastType;
import 'package:material_ui/material_ui.dart';

/// The toast currently shown by [showGlassToast], replaced by the next one.
_GlassToastEntry? _currentToast;

/// Shows an iOS liquid glass toast at the top of [overlay], replacing the toast already shown.
///
/// The package's `GlassToast.show` can't be used directly: it inserts the toast in the nearest
/// overlay (a tab's navigator, under the app bars of its screens) and stacks every toast it shows.
void showGlassToast(
  OverlayState overlay,
  String message, {
  GlassToastType type = GlassToastType.info,
  Duration duration = const Duration(seconds: 4),
}) {
  _currentToast?.dismiss();
  final toast = _GlassToastEntry();
  _currentToast = toast;
  toast.entry = OverlayEntry(
    builder: (context) => _GlassToastOverlay(
      key: toast.key,
      message: message,
      type: type,
      duration: duration,
      onDismissed: () {
        toast.entry.remove();
        if (_currentToast == toast) _currentToast = null;
      },
    ),
  );
  overlay.insert(toast.entry);
}

class _GlassToastEntry() {
  final key = GlobalKey<_GlassToastOverlayState>();
  late final OverlayEntry entry;

  void dismiss() => key.currentState?.dismiss();
}

/// Slides a [GlassToast] in from the top of the screen, and out after [duration] or a swipe up.
class const _GlassToastOverlay({
  super.key,
  required final String message,
  required final GlassToastType type,
  required final Duration duration,
  required final VoidCallback onDismissed,
}) extends StatefulWidget {
  @override
  State<_GlassToastOverlay> createState() => _GlassToastOverlayState();
}

class _GlassToastOverlayState()
    extends State<_GlassToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  Timer? _timer;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Slides the toast out, then removes it.
  Future<void> dismiss() async {
    if (_isDismissed) return;
    _isDismissed = true;
    _timer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  void _removeNow() {
    if (_isDismissed) return;
    _isDismissed = true;
    _timer?.cancel();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8.0,
      left: 16.0,
      right: 16.0,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, -1.5), end: Offset.zero).animate(_curve),
        child: FadeTransition(
          opacity: _curve,
          child: Center(
            child: Dismissible(
              key: const ValueKey('glass_toast'),
              direction: DismissDirection.up,
              onDismissed: (_) => _removeNow(),
              child: Material(
                type: MaterialType.transparency,
                child: GlassToast(
                  message: widget.message,
                  type: widget.type,
                  position: GlassToastPosition.top,
                  onDismissed: dismiss,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
