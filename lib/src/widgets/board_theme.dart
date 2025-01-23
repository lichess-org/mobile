import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

/// Applies the configured board theme to the child widget.
///
/// Typically used in screens that need to display a chess board.
class BoardTheme extends ConsumerWidget {
  const BoardTheme({required this.child, this.backgroundTheme, super.key});

  final Widget child;
  final BoardBackgroundTheme? backgroundTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final effectiveBackgroundTheme = backgroundTheme ?? boardPrefs.backgroundTheme;

    if (effectiveBackgroundTheme == null) {
      return child;
    }

    final boardTheme = boardPrefs.boardTheme;
    final flexScheme = effectiveBackgroundTheme.getFlexScheme(boardTheme);
    final isTablet = isTabletOrLarger(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final flexSchemeLightColors = flexScheme.light;
    final flexSchemeDarkColors = flexScheme.dark;

    final lightTheme = FlexThemeData.light(
      colors: flexSchemeLightColors,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
      blendLevel: 20,
    );
    final darkTheme =
        FlexColorScheme.dark(
          colors: flexSchemeDarkColors,
          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
          blendLevel: 20,
          cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
          appBarStyle: isIOS ? null : FlexAppBarStyle.scaffoldBackground,
        ).toTheme;

    final lightCupertinoTheme = CupertinoThemeData(
      primaryColor: lightTheme.colorScheme.primary,
      primaryContrastingColor: lightTheme.colorScheme.onPrimary,
      brightness: Brightness.light,
      textTheme: CupertinoTheme.of(context).textTheme.copyWith(
        primaryColor: lightTheme.colorScheme.primary,
        textStyle: CupertinoTheme.of(
          context,
        ).textTheme.textStyle.copyWith(color: lightTheme.colorScheme.onSurface),
        navTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
        navLargeTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navLargeTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
      ),
      scaffoldBackgroundColor: lightTheme.scaffoldBackgroundColor,
      barBackgroundColor: lightTheme.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      applyThemeToAll: true,
    );

    final darkCupertinoTheme = CupertinoThemeData(
      primaryColor: darkTheme.colorScheme.primary,
      primaryContrastingColor: darkTheme.colorScheme.onPrimary,
      brightness: Brightness.dark,
      textTheme: CupertinoTheme.of(context).textTheme.copyWith(
        primaryColor: darkTheme.colorScheme.primary,
        textStyle: CupertinoTheme.of(
          context,
        ).textTheme.textStyle.copyWith(color: darkTheme.colorScheme.onSurface),
        navTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
        navLargeTitleTextStyle: CupertinoTheme.of(
          context,
        ).textTheme.navLargeTitleTextStyle.copyWith(color: Styles.cupertinoTitleColor),
      ),
      scaffoldBackgroundColor: darkTheme.scaffoldBackgroundColor,
      barBackgroundColor: darkTheme.appBarTheme.backgroundColor?.withValues(
        alpha: isTablet ? 1.0 : 0.9,
      ),
      applyThemeToAll: true,
    );

    final brightness = Theme.of(context).brightness;

    final theme = brightness == Brightness.light ? lightTheme : darkTheme;
    final cupertinoTheme =
        brightness == Brightness.light ? lightCupertinoTheme : darkCupertinoTheme;

    return Theme(
      data: theme.copyWith(
        cupertinoOverrideTheme: cupertinoTheme,
        splashFactory: isIOS ? NoSplash.splashFactory : null,
        textTheme:
            isIOS
                ? brightness == Brightness.light
                    ? Typography.blackCupertino
                    : Typography.whiteCupertino
                : null,
        extensions: [lichessCustomColors.harmonized(darkTheme.colorScheme)],
      ),
      child:
          isIOS
              ? CupertinoTheme(
                data: cupertinoTheme,
                child: IconTheme.merge(
                  data: IconThemeData(color: CupertinoTheme.of(context).textTheme.textStyle.color),
                  child: child,
                ),
              )
              : child,
    );
  }
}
