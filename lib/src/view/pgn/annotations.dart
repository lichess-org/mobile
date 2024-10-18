import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

const innacuracyColor = LichessColors.cyan;
const mistakeColor = Color(0xFFe69f00);
const blunderColor = Color(0xFFdf5353);

Color? nagColor(int nag) {
  return switch (nag) {
    1 => Colors.lightGreen,
    2 => mistakeColor,
    3 => Colors.teal,
    4 => blunderColor,
    5 => LichessColors.purple,
    6 => LichessColors.cyan,
    int() => null,
  };
}

String moveAnnotationChar(Iterable<int> nags) {
  return nags
      .map(
        (nag) => switch (nag) {
          1 => '!',
          2 => '?',
          3 => '!!',
          4 => '??',
          5 => '!?',
          6 => '?!',
          int() => '',
        },
      )
      .join('');
}

Annotation? makeAnnotation(Iterable<int>? nags) {
  final nag = nags?.firstOrNull;
  if (nag == null) {
    return null;
  }
  return switch (nag) {
    1 => const Annotation(
        symbol: '!',
        color: Colors.lightGreen,
      ),
    3 => const Annotation(
        symbol: '!!',
        color: Colors.teal,
      ),
    5 => const Annotation(
        symbol: '!?',
        color: Colors.purple,
      ),
    6 => const Annotation(
        symbol: '?!',
        color: LichessColors.cyan,
      ),
    2 => const Annotation(
        symbol: '?',
        color: mistakeColor,
      ),
    4 => const Annotation(
        symbol: '??',
        color: blunderColor,
      ),
    int() => null,
  };
}
