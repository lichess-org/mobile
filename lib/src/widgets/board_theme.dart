import 'dart:io' show File;
import 'dart:ui' show ImageFilter;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// Applies the configured board theme to the child widget.
///
/// Typically used in screens that need to display a chess board.
class BoardBackgroundThemeWidget extends ConsumerWidget {
  const BoardBackgroundThemeWidget({
    required this.child,
    this.backgroundImage,
    this.backgroundTheme,
    super.key,
  });

  final Widget child;
  final BoardBackgroundImage? backgroundImage;
  final BoardBackgroundTheme? backgroundTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final effectiveBackgroundTheme = backgroundTheme ?? boardPrefs.backgroundTheme;
    final effectiveBackgroundImage = backgroundImage ?? boardPrefs.backgroundImage;

    if (effectiveBackgroundTheme == null && effectiveBackgroundImage == null) {
      return child;
    }

    if (effectiveBackgroundImage != null) {
      return _BoardBackgroundImage(backgroundImage: effectiveBackgroundImage, child: child);
    } else {
      return _BoardBackgroundTheme(
        backgroundTheme: effectiveBackgroundTheme!,
        boardTheme: boardPrefs.boardTheme,
        child: child,
      );
    }
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
      blendLevel: 16,
    );
    final darkTheme =
        FlexColorScheme.dark(
          colors: flexScheme.dark,
          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
          blendLevel: 20,
          cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
          appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
        ).toTheme;

    final brightness = Theme.of(context).brightness;

    final theme = brightness == Brightness.light ? lightTheme : darkTheme;
    final cupertinoTheme = _makeCupertinoTheme(theme, brightness: brightness);

    return _ThemeWrapper(
      isIOS: isIOS,
      theme: theme,
      cupertinoTheme: cupertinoTheme,
      brightness: brightness,
      child: child,
    );
  }
}

class _BoardBackgroundImage extends StatelessWidget {
  const _BoardBackgroundImage({required this.backgroundImage, required this.child});

  final BoardBackgroundImage backgroundImage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final theme = FlexThemeData.dark(
      colors: FlexSchemeColor(
        primary: backgroundImage.darkColors.primary,
        primaryContainer: backgroundImage.darkColors.primaryContainer,
        secondary: backgroundImage.darkColors.secondary,
        secondaryContainer: backgroundImage.darkColors.secondaryContainer,
        tertiary: backgroundImage.darkColors.tertiary,
        tertiaryContainer: backgroundImage.darkColors.tertiaryContainer,
        error: backgroundImage.darkColors.error,
        errorContainer: backgroundImage.darkColors.errorContainer,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      appBarOpacity: 0,
    );

    final cupertinoTheme = _makeCupertinoTheme(
      theme,
      brightness: Brightness.dark,
      transparentScaffold: true,
    );

    final content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(backgroundImage.path)),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Color(0x44000000), BlendMode.srcOver),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          enabled: backgroundImage.isBlurred,
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: child,
        ),
      ),
    );

    return _ThemeWrapper(
      isIOS: isIOS,
      theme: theme,
      cupertinoTheme: cupertinoTheme,
      brightness: Brightness.dark,
      transparentScaffold: true,
      child: content,
    );
  }
}

class _ThemeWrapper extends StatelessWidget {
  const _ThemeWrapper({
    required this.child,
    required this.isIOS,
    required this.theme,
    required this.cupertinoTheme,
    required this.brightness,
    this.transparentScaffold = false,
  });

  final Widget child;
  final bool isIOS;
  final ThemeData theme;
  final CupertinoThemeData cupertinoTheme;
  final Brightness brightness;
  final bool transparentScaffold;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
        cupertinoOverrideTheme: cupertinoTheme,
        listTileTheme: ListTileTheme.of(context).copyWith(
          tileColor: theme.colorScheme.surfaceContainerLow.withValues(
            alpha: transparentScaffold ? 0.5 : 1,
          ),
          selectedTileColor: theme.colorScheme.surfaceContainer.withValues(
            alpha: transparentScaffold ? 0.5 : 1,
          ),
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

CupertinoThemeData _makeCupertinoTheme(
  ThemeData theme, {
  Brightness brightness = Brightness.light,
  bool transparentScaffold = false,
}) {
  return CupertinoThemeData(
    primaryColor: theme.colorScheme.primary,
    primaryContrastingColor: theme.colorScheme.onPrimary,
    brightness: brightness,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: theme.colorScheme.primary,
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
    barBackgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha: 0),
    applyThemeToAll: true,
  );
}
