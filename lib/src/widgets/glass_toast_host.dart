import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart' show SnackBarType;
import 'package:lichess_mobile/src/widgets/platform.dart' show ios27GlassSettings, useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// The toast currently shown by [showGlassToast], replaced by the next one.
_GlassToastEntry? _currentToast;

/// Shows an iOS liquid glass toast at the top of [overlay], replacing the toast already shown.
///
/// The package's `GlassToast` isn't used: its `show` inserts the toast in the nearest overlay (a
/// tab's navigator, under the app bars of its screens) and stacks every toast it shows, and its
/// translucent fill and fixed semantic colors don't follow the app theme.
void showGlassToast(
  OverlayState overlay,
  String message, {
  SnackBarType type = SnackBarType.info,
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

/// Slides a toast in from the top of the screen, and out after [duration] or a swipe up.
class const _GlassToastOverlay({
  super.key,
  required final String message,
  required final SnackBarType type,
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

  static const double _kBorderRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final background = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            switch (widget.type) {
              .error => CupertinoIcons.xmark_circle_fill,
              .info => CupertinoIcons.info_circle_fill,
              .success => CupertinoIcons.check_mark_circled_solid,
            },
            color: switch (widget.type) {
              .error => colorScheme.error,
              .info => context.lichessColors.cyan,
              .success => context.lichessColors.good,
            },
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              widget.message,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8.0,
      left: 16.0,
      right: 16.0,
      child: SlideTransition(
        // No fade: the toast slides in from fully above the screen, opaque all along.
        position: Tween(begin: const Offset(0, -2.0), end: Offset.zero).animate(_curve),
        child: Center(
          child: Dismissible(
            key: const ValueKey('glass_toast'),
            direction: DismissDirection.up,
            onDismissed: (_) => _removeNow(),
            child: Material(
              type: MaterialType.transparency,
              child: Semantics(
                liveRegion: true,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: !useLiquidGlass(context)
                      // Opaque before iOS 26, with a shadow to stand out over the content.
                      ? DecoratedBox(
                          decoration: ShapeDecoration(
                            color: background,
                            shape: const RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.all(Radius.circular(_kBorderRadius)),
                            ),
                            shadows: const [BoxShadow(color: Color(0x33000000), blurRadius: 16.0)],
                          ),
                          child: content,
                        )
                      : GlassContainer(
                          // The toast floats alone over the content, with no parent glass layer.
                          useOwnLayer: true,
                          shape: const LiquidRoundedSuperellipse(borderRadius: _kBorderRadius),
                          // An opaque neutral glass, for the message to read over any content.
                          // A translucent one shows through while the toast slides in and out.
                          settings: ios27GlassSettings(context).copyWith(glassColor: background),
                          child: content,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
