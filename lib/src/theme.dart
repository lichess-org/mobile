import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.greys,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.greys,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 20,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  static final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppTheme.light.colorScheme.secondaryFixedDim,
    foregroundColor: AppTheme.light.colorScheme.onSecondaryFixedVariant,
  );

  static const cupertinoTitleColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFF5F5F5),
  );

  static final lightCupertino = CupertinoThemeData(
    primaryColor: AppTheme.light.colorScheme.primary,
    primaryContrastingColor: AppTheme.light.colorScheme.onPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppTheme.light.scaffoldBackgroundColor,
    barBackgroundColor: AppTheme.light.appBarTheme.backgroundColor,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: AppTheme.light.colorScheme.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: AppTheme.light.colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: cupertinoTitleColor,
      ),
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: cupertinoTitleColor,
      ),
    ),
  );

  static final darkCupertino = CupertinoThemeData(
    primaryColor: AppTheme.dark.colorScheme.primary,
    primaryContrastingColor: AppTheme.dark.colorScheme.onPrimary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppTheme.dark.scaffoldBackgroundColor,
    barBackgroundColor: AppTheme.dark.appBarTheme.backgroundColor,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: AppTheme.dark.colorScheme.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: AppTheme.dark.colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: cupertinoTitleColor,
      ),
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: cupertinoTitleColor,
      ),
    ),
  );
}
