import 'package:flutter/widgets.dart';

abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const sectionTitle = TextStyle(fontSize: 16);
  static const subtitleOpacity = 0.7;

  // spacing
  static const bodyPadding =
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0);
}
