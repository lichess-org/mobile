import 'package:flutter/material.dart';

class LichessColors {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  LichessColors._();

  // material colors palette generated with:
  // http://mmbitson.com

  // primary: blue
  static const MaterialColor primary =
      MaterialColor(_primaryPrimaryValue, <int, Color>{
        50: Color(0xFFE4EFF9),
        100: Color(0xFFBBD7F1),
        200: Color(0xFF8DBCE8),
        300: Color(0xFF5FA1DE),
        400: Color(0xFF3D8CD7),
        500: Color(_primaryPrimaryValue),
        600: Color(0xFF1870CB),
        700: Color(0xFF1465C4),
        800: Color(0xFF105BBE),
        900: Color(0xFF0848B3),
      });
  static const int _primaryPrimaryValue = 0xFF1B78D0;

  // secondary: green
  static const MaterialColor secondary =
      MaterialColor(_secondaryPrimaryValue, <int, Color>{
        50: Color(0xFFECF3E5),
        100: Color(0xFFD0E0BD),
        200: Color(0xFFB1CC92),
        300: Color(0xFF91B866),
        400: Color(0xFF7AA845),
        500: Color(_secondaryPrimaryValue),
        600: Color(0xFF5A9120),
        700: Color(0xFF50861B),
        800: Color(0xFF467C16),
        900: Color(0xFF346B0D),
      });
  static const int _secondaryPrimaryValue = 0xFF629924;

  // accent: orange
  static const MaterialColor accent =
      MaterialColor(_accentPrimaryValue, <int, Color>{
        50: Color(0xFFFAEAE0),
        100: Color(0xFFF3CAB3),
        200: Color(0xFFEBA780),
        300: Color(0xFFE2844D),
        400: Color(0xFFDC6926),
        500: Color(_accentPrimaryValue),
        600: Color(0xFFD14800),
        700: Color(0xFFCC3F00),
        800: Color(0xFFC63600),
        900: Color(0xFFBC2600),
      });
  static const int _accentPrimaryValue = 0xFFD64F00;

  // brag: gold
  static const brag = Color(0xFFBF811D);

  // fancy: pink
  static const fancy = Color(0xFFB72FC6);

  // error: red
  static const MaterialColor red = MaterialColor(_redPrimaryValue, <int, Color>{
    50: Color(0xFFF9E7E7),
    100: Color(0xFFF0C2C2),
    200: Color(0xFFE69999),
    300: Color(0xFFDB7070),
    400: Color(0xFFD45252),
    500: Color(_redPrimaryValue),
    600: Color(0xFFC72E2E),
    700: Color(0xFFC02727),
    800: Color(0xFFB92020),
    900: Color(0xFFAD1414),
  });
  static const int _redPrimaryValue = 0xFFCC3333;
  static const error = red;

  // offline: grey
  static const grey = Color(0xCCCCCCCC);

  // good: green
  static const green = secondary;
  static const good = secondary;

  static const warn = brag;

  static const cyan = Color(0xFF56B4E9);
  static const blue = Color(0xFF0072B2);
  static const purple = Color(0xFF8572ff);
}
