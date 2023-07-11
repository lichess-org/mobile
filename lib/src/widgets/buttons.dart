import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';

/// Platform agnostic button which is used for important actions.
///
/// Will use an [ElevatedButton] on Android and a [CupertinoButton.filled] on iOS.
class FatButton extends StatelessWidget {
  const FatButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    super.key,
  });

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoButton.filled(onPressed: onPressed, child: child)
          : FilledButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: child,
            ),
    );
  }
}

/// Platform agnostic button meant for medium importance actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    this.textStyle,
    super.key,
  });

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoButton(
              onPressed: onPressed,
              child: child,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                textStyle: textStyle,
              ),
              child: child,
            ),
    );
  }
}

class AppBarTextButton extends StatelessWidget {
  const AppBarTextButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: child,
          )
        : TextButton(
            onPressed: onPressed,
            child: child,
          );
  }
}

/// Button that explicitly reduce padding, thus does not conform to accessibility
/// guidelines. So use sparingly.
class NoPaddingTextButton extends StatelessWidget {
  const NoPaddingTextButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            minSize: 23,
            child: child,
          )
        : TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: child,
          );
  }
}

/// Cupertino icon button with mandatory semantics label
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    required this.onPressed,
    required this.semanticsLabel,
    required this.icon,
    this.padding,
    super.key,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final String semanticsLabel;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: CupertinoButton(
        padding: padding,
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}

class BottomBarIconButton extends StatelessWidget {
  const BottomBarIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    this.padding,
    this.showTooltip = true,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final bool showTooltip;

  /// The padding around the button's icon. The entire padded icon will react
  /// to input gestures.
  ///
  /// If null, it defaults to 8.0 padding on all sides on Android and 16.0 on iOS.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        return CupertinoTheme(
          data: themeData.copyWith(
            primaryColor: themeData.textTheme.textStyle.color,
          ),
          child: CupertinoIconButton(
            onPressed: onPressed,
            icon: icon,
            semanticsLabel: semanticsLabel,
          ),
        );
      case TargetPlatform.android:
        return Theme(
          data: Theme.of(context),
          child: IconButton(
            tooltip: showTooltip ? semanticsLabel : null,
            padding: padding,
            onPressed: onPressed,
            icon: icon,
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// A bottom bar button that can shows an icon and text on iOS and an icon only
/// on Android.
class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    required this.icon,
    required this.label,
    required this.shortLabel,
    required this.onTap,
    this.showAndroidTooltip = true,
    this.highlighted = false,
    this.showAndroidShortLabel = false,
  });

  final IconData icon;
  final String label;
  final String shortLabel;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool showAndroidShortLabel;
  final bool showAndroidTooltip;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final themeData = Theme.of(context);
        return Theme(
          data: themeData,
          child: SizedBox(
            height: 50,
            child: showAndroidShortLabel
                ? TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(icon),
                    label: Text(shortLabel),
                    style: TextButton.styleFrom(
                      foregroundColor: themeData.colorScheme.onBackground,
                    ),
                  )
                : IconButton(
                    onPressed: onTap,
                    icon: Icon(icon),
                    tooltip: showAndroidTooltip ? label : null,
                    color: highlighted ? themeData.colorScheme.primary : null,
                  ),
          ),
        );
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        final hightlightedColor = themeData.primaryColor;
        return CupertinoTheme(
          data: themeData.copyWith(
            primaryColor: themeData.textTheme.textStyle.color,
          ),
          child: SizedBox(
            height: 50,
            child: Semantics(
              container: true,
              enabled: true,
              button: true,
              label: label,
              excludeSemantics: true,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: highlighted ? hightlightedColor : null),
                    Text(
                      shortLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: highlighted ? hightlightedColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// A button that looks like a ListTile on a Card.
class CardButton extends StatefulWidget {
  const CardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final Widget title;
  final Widget subtitle;
  final VoidCallback? onTap;

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  double scale = 1.0;

  void _onTapDown() {
    if (widget.onTap == null) return;
    setState(() => scale = 0.96);
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    setState(() => scale = 1.00);
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Opacity(
          opacity: widget.onTap == null ? 0.4 : 1.0,
          child: PlatformCard(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                  leading: widget.icon,
                  title: widget.title,
                  subtitle: widget.subtitle,
                ),
              ),
            ),
          ),
        );
      case TargetPlatform.iOS:
        return GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => _onTapDown(),
          onTapCancel: _onTapCancel,
          onTapUp: (_) => _onTapCancel(),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 100),
            child: Opacity(
              opacity: widget.onTap == null ? 0.4 : 1.0,
              child: PlatformCard(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListTileTheme(
                    data: ListTileThemeData(
                      iconColor:
                          CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                    child: ListTile(
                      leading: widget.icon,
                      title: widget.title,
                      subtitle: widget.subtitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// InkWell that adapts to the iOS platform.
///
/// Used to create a button that shows a ripple on Android and a highlight on iOS.
class AdaptiveInkWell extends StatefulWidget {
  const AdaptiveInkWell({
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<AdaptiveInkWell> createState() => _AdaptiveInkWellState();
}

class _AdaptiveInkWellState extends State<AdaptiveInkWell> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return InkWell(
          onTap: widget.onTap,
          borderRadius: widget.borderRadius,
          child: widget.child,
        );
      case TargetPlatform.iOS:
        return GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: _isPressed
                  ? CupertinoDynamicColor.resolve(
                      CupertinoColors.systemGrey4,
                      context,
                    )
                  : null,
            ),
            child: widget.child,
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// Button to repeatedly call a funtion, triggered after a long press.
///
/// This widget is just a wrapper, the visuals are delegated to the child widget.
///
/// ### Notes
/// Child widgets with a `tooltip` already have an `onLongPress` callback that will
/// conflict.
/// `onTap` callback should be handled by the child widget.
class RepeatButton extends StatefulWidget {
  const RepeatButton({
    required this.onLongPress,
    required this.child,
    this.triggerDelays = const [
      Duration(milliseconds: 500),
      Duration(milliseconds: 300),
      Duration(milliseconds: 150),
    ],
    this.holdDelay = const Duration(milliseconds: 50),
  });

  final Widget child;

  /// function called on long press
  final VoidCallback? onLongPress;

  /// Delays between callbacks at the beginning. Leave default to get an acceleration effect.
  /// The maximum length of the list is 3
  final List<Duration> triggerDelays;

  /// Delay between callbacks
  final Duration holdDelay;

  @override
  _RepeatButtonState createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  bool _isPressed = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onPress() async {
    _isPressed = true;

    widget.onLongPress?.call();
    for (final time in widget.triggerDelays) {
      await Future.delayed(time, () {});
      if (!_isPressed) return;
      widget.onLongPress?.call();
    }

    _timer = Timer.periodic(widget.holdDelay, (_) {
      if (_isPressed) {
        widget.onLongPress?.call();
      }
    });
  }

  void _onPressEnd() {
    _isPressed = false;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: _onPress,
      onLongPressCancel: _onPressEnd,
      onLongPressUp: _onPressEnd,
      child: widget.child,
    );
  }
}

/// Platform agnostic icon button
///
/// Optionally provide a bool to highlight the button
/// Will use [IconButton] on Android and [CupertinoIconButton] on iOS.
class PlatformIconButton extends StatelessWidget {
  const PlatformIconButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    this.highlighted = true,
  });

  final IconData icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final themeData = Theme.of(context);
        return Theme(
          data: themeData,
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
            tooltip: semanticsLabel,
            color: highlighted ? themeData.colorScheme.primary : null,
          ),
        );
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        return CupertinoTheme(
          data: themeData.copyWith(
            primaryColor: themeData.textTheme.textStyle.color,
          ),
          child: CupertinoIconButton(
            onPressed: onTap,
            semanticsLabel: semanticsLabel,
            icon: Icon(
              icon,
              color: highlighted ? themeData.primaryColor : null,
            ),
          ),
        );
      default:
        assert(false, 'Unexpected Platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
