import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class AppTheme {
  static const FlexSchemeData defaultScheme = FlexColor.espresso;

  static final ThemeData _light = FlexThemeData.light(
    scheme: FlexScheme.espresso,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    appBarStyle:
        defaultTargetPlatform == TargetPlatform.iOS ? null : FlexAppBarStyle.scaffoldBackground,
  );
  // The defined dark theme.
  static final ThemeData _dark = FlexThemeData.dark(
    scheme: FlexScheme.espresso,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 20,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    appBarStyle:
        defaultTargetPlatform == TargetPlatform.iOS ? null : FlexAppBarStyle.scaffoldBackground,
  );

  static const cupertinoTitleColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFF5F5F5),
  );

  static final lightCupertino = CupertinoThemeData(
    primaryColor: _light.colorScheme.primary,
    primaryContrastingColor: _light.colorScheme.onPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _light.scaffoldBackgroundColor,
    barBackgroundColor: _light.appBarTheme.backgroundColor,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: _light.colorScheme.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: _light.colorScheme.onSurface,
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
    primaryColor: _dark.colorScheme.primaryFixed,
    primaryContrastingColor: _dark.colorScheme.onPrimaryFixed,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _dark.scaffoldBackgroundColor,
    barBackgroundColor: _dark.appBarTheme.backgroundColor,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: _dark.colorScheme.primaryFixed,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: _dark.colorScheme.onSurface,
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
