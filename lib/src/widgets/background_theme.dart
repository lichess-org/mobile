import 'dart:io' show File;
import 'dart:ui' show ImageFilter;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// Applies the configured theme to the child widget.
///
/// Tries first to apply the theme provided ar argument, and then from the stored settings.
class BackgroundThemeWidget extends ConsumerWidget {
  const BackgroundThemeWidget({required this.child, this.backgroundTheme, super.key});

  /// The child widget to apply the theme to.
  final Widget child;

  /// The background theme to apply to the child. If null, the theme from the stored settings will be used.
  final BoardBackgroundTheme? backgroundTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    if (backgroundTheme == null &&
        boardPrefs.backgroundTheme == null &&
        boardPrefs.backgroundImage == null) {
      return child;
    }

    if (backgroundTheme != null) {
      return _BoardBackgroundTheme(
        backgroundTheme: backgroundTheme!,
        boardTheme: boardPrefs.boardTheme,
        child: child,
      );
    } else if (boardPrefs.backgroundImage != null) {
      return _BoardBackgroundImage(backgroundImage: boardPrefs.backgroundImage!, child: child);
    } else {
      return _BoardBackgroundTheme(
        backgroundTheme: boardPrefs.backgroundTheme!,
        boardTheme: boardPrefs.boardTheme,
        child: child,
      );
    }
  }
}

/// Applies the configured background theme to the child widget.
class BackgroundThemeWrapper extends StatelessWidget {
  const BackgroundThemeWrapper({
    required this.child,
    required this.theme,
    required this.brightness,
    this.transparentScaffold = false,
  });

  /// The child widget to apply the theme to.
  final Widget child;

  /// The theme to apply to the child.
  final ThemeData theme;

  /// The brightness of the theme.
  final Brightness brightness;

  /// If true, the scaffold background will be transparent. Useful for displaying a background image.
  final bool transparentScaffold;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final cupertinoTheme = _makeCupertinoTheme(
      theme,
      brightness: brightness,
      transparentScaffold: transparentScaffold,
    );

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surface: theme.colorScheme.surface.withValues(alpha: transparentScaffold ? 0.6 : 1),
          surfaceContainerLowest: theme.colorScheme.surfaceContainerLowest.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerLow: theme.colorScheme.surfaceContainerLow.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainer: theme.colorScheme.surfaceContainer.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerHigh: theme.colorScheme.surfaceContainerHigh.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceContainerHighest: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: transparentScaffold ? 0.6 : 1,
          ),
          surfaceDim: theme.colorScheme.surfaceDim.withValues(alpha: transparentScaffold ? 0.8 : 1),
          surfaceBright: theme.colorScheme.surfaceBright.withValues(
            alpha: transparentScaffold ? 0.4 : 1,
          ),
        ),
        cupertinoOverrideTheme: cupertinoTheme,
        listTileTheme: ListTileTheme.of(context).copyWith(
          titleTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
          subtitleTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
          leadingAndTrailingTextStyle: isIOS ? cupertinoTheme.textTheme.textStyle : null,
        ),
        scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
          alpha: transparentScaffold ? 0 : 1,
        ),
        splashFactory: isIOS ? NoSplash.splashFactory : null,
        textTheme:
            isIOS
                ? brightness == Brightness.light
                    ? Typography.blackCupertino
                    : Typography.whiteCupertino
                : null,
        extensions: [lichessCustomColors.harmonized(theme.colorScheme)],
      ),
      child: isIOS ? CupertinoTheme(data: cupertinoTheme, child: child) : child,
    );
  }
}

class _BoardBackgroundTheme extends StatelessWidget {
  const _BoardBackgroundTheme({
    required this.backgroundTheme,
    required this.boardTheme,
    required this.child,
  });

  final Widget child;
  final BoardTheme boardTheme;
  final BoardBackgroundTheme backgroundTheme;

  @override
  Widget build(BuildContext context) {
    final flexScheme = backgroundTheme.getFlexScheme(boardTheme);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final lightTheme = FlexThemeData.light(
      colors: flexScheme.light,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
      blendLevel: backgroundTheme.lightBlend,
    );
    final darkTheme = FlexThemeData.dark(
      colors: flexScheme.dark,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: backgroundTheme.darkBlend,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
    );

    final brightness = Theme.of(context).brightness;
    final theme = brightness == Brightness.light ? lightTheme : darkTheme;

    return BackgroundThemeWrapper(theme: theme, brightness: brightness, child: child);
  }
}

class _BoardBackgroundImage extends StatefulWidget {
  const _BoardBackgroundImage({required this.backgroundImage, required this.child});

  final BoardBackgroundImage backgroundImage;
  final Widget child;

  @override
  State<_BoardBackgroundImage> createState() => _BoardBackgroundImageState();
}

class _BoardBackgroundImageState extends State<_BoardBackgroundImage> {
  late TransformationController _controller;

  @override
  void initState() {
    _controller = TransformationController(widget.backgroundImage.transform);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundThemeWrapper(
      theme: widget.backgroundImage.theme,
      brightness: Brightness.dark,
      transparentScaffold: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
                transformationController: _controller,
                constrained: false,
                minScale: 1,
                maxScale: 2,
                panEnabled: false,
                scaleEnabled: false,
                child: Container(
                  width: constraints.minWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(widget.backgroundImage.path)),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        widget.backgroundImage.filterColor,
                        BlendMode.srcOver,
                      ),
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      enabled: widget.backgroundImage.isBlurred,
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: widget.child),
            ],
          );
        },
      ),
    );
  }
}

CupertinoThemeData _makeCupertinoTheme(
  ThemeData theme, {
  Brightness brightness = Brightness.light,
  bool transparentScaffold = false,
}) {
  final primary = theme.colorScheme.primary;
  final onPrimary = theme.colorScheme.onPrimary;
  return CupertinoThemeData(
    primaryColor: primary,
    primaryContrastingColor: onPrimary,
    brightness: brightness,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: Styles.cupertinoTitleColor,
      ),
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: Styles.cupertinoTitleColor,
      ),
    ),
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
      alpha: transparentScaffold ? 0 : 1,
    ),
    barBackgroundColor: theme.appBarTheme.backgroundColor?.withValues(
      alpha: transparentScaffold ? 0.5 : 0.9,
    ),
    applyThemeToAll: true,
  );
}
