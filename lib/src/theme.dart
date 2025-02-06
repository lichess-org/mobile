import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class AppTheme {
  static const lightColors = FlexSchemeColor(
    // Custom colors
    primary: Color(0xFF5F4A45),
    primaryContainer: Color(0xFFC7BCAC),
    primaryLightRef: Color(0xFF5F4A45),
    secondary: Color(0xFFE3B964),
    secondaryContainer: Color(0xFFFFDE9C),
    secondaryLightRef: Color(0xFFE3B964),
    tertiary: Color(0xFFF5E9C9),
    tertiaryContainer: Color(0xFFFEE7AD),
    tertiaryLightRef: Color(0xFFF5E9C9),
    appBarColor: Color(0xFFFFDE9C),
    error: Color(0xFFB00020),
    errorContainer: Color(0xFFFFDAD6),
  );

  static const darkColors = FlexSchemeColor(
    primary: Color(0xFFF8ECD4),
    primaryContainer: Color(0xFF705D49),
    primaryLightRef: Color(0xFF5F4A45),
    secondary: Color(0xFFEED6A6),
    secondaryContainer: Color(0xFF8E774F),
    secondaryLightRef: Color(0xFFE3B964),
    tertiary: Color(0xFF8D7F7D),
    tertiaryContainer: Color(0xFF452F2B),
    tertiaryLightRef: Color(0xFFF5E9C9),
    appBarColor: Color(0xFFFFDE9C),
    error: Color(0xFFCF6679),
    errorContainer: Color(0xFF93000A),
  );
}
