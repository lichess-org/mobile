import 'dart:math';

import 'package:flutter/material.dart';

// Based upon: https://stackoverflow.com/questions/64639589/how-to-adjust-hue-saturation-and-brightness-of-an-image-in-flutter
// from BananaNeil: https://stackoverflow.com/users/937841/banananeil.
// This is, in turn, based upon: https://stackoverflow.com/a/7917978/937841

/// Use the [ChangeColors] widget to change the brightness and hue of any widget, including images.
///
/// Example:
///
/// ```
/// ChangeColors(
///    hue: 0.55,
///    brightness: 0.2,
///    child: Image.asset('myImage.png'),
/// );
/// ```
class ChangeColors extends StatelessWidget {
  const ChangeColors({this.brightness = 0.0, this.hue = 0.0, required this.child, super.key});

  /// Negative value will make it darker (-1 is darkest).
  /// Positive value will make it lighter (1 is the maximum, but you can go above it).
  /// Note: 0.0 is unchanged.
  final double brightness;

  /// From -1.0 to 1.0 (Note: 1.0 wraps into -1.0, such as 1.2 is the same as -0.8).
  /// Note: 0.0 is unchanged. Adding or subtracting multiples of 2.0 also keeps it unchanged.
  final double hue;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_adjustMatrix(hue: hue * pi, brightness: brightness)),
      child: child,
    );
  }
}

List<double> _adjustMatrix({required double hue, required double brightness}) {
  if (hue == 0 && brightness == 0) {
    // dart format off
    return [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];
    // dart format on
  }
  final brightnessValue = brightness <= 0 ? brightness * 100 : brightness * 100;
  return List<double>.from(<double>[
    0.213 + cos(hue) * 0.787 + sin(hue) * -0.213,
    0.715 + cos(hue) * -0.715 + sin(hue) * -0.715,
    0.072 + cos(hue) * -0.072 + sin(hue) * 0.928,
    0,
    brightnessValue,
    0.213 + cos(hue) * -0.213 + sin(hue) * 0.143,
    0.715 + cos(hue) * 0.285 + sin(hue) * 0.140,
    0.072 + cos(hue) * -0.072 + sin(hue) * -0.283,
    0,
    brightnessValue,
    0.213 + cos(hue) * -0.213 + sin(hue) * -0.787,
    0.715 + cos(hue) * -0.715 + sin(hue) * 0.715,
    0.072 + cos(hue) * 0.928 + sin(hue) * 0.072,
    0,
    brightnessValue,
    0,
    0,
    0,
    1,
    0,
  ]).map((i) => i).toList();
}
