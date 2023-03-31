import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

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
          : ElevatedButton(
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
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          textStyle: textStyle,
          padding: defaultTargetPlatform == TargetPlatform.iOS
              ? const EdgeInsets.all(10.0)
              : null,
          shape: defaultTargetPlatform == TargetPlatform.iOS
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
              : null,
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

/// Cupertino icon button with mandatory semantics label
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    required this.onPressed,
    required this.semanticsLabel,
    required this.icon,
    super.key,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
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
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;

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
            tooltip: semanticsLabel,
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
    this.highlighted = false,
    this.showAndroidShortLabel = false,
  });

  final IconData icon;
  final String label;
  final String shortLabel;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool showAndroidShortLabel;

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
                    tooltip: label,
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
    setState(() => scale = 0.98);
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    setState(() => scale = 1.00);
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListTile(
                leading: widget.icon,
                title: widget.title,
                subtitle: widget.subtitle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleSoundButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return IconButton(
          // TODO translate
          tooltip: 'Toggle sound',
          icon: isSoundEnabled
              ? const Icon(Icons.volume_up)
              : const Icon(Icons.volume_off),
          onPressed: () => ref
              .read(generalPreferencesProvider.notifier)
              .toggleSoundEnabled(),
        );
      case TargetPlatform.iOS:
        return CupertinoIconButton(
          semanticsLabel: 'Toggle sound',
          icon: isSoundEnabled
              ? const Icon(CupertinoIcons.volume_up)
              : const Icon(CupertinoIcons.volume_off),
          onPressed: () => ref
              .read(generalPreferencesProvider.notifier)
              .toggleSoundEnabled(),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
