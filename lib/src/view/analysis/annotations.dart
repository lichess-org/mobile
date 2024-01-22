import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

const innacuracyColor = LichessColors.cyan;
const mistakeColor = Color(0xFFe69f00);
const blunderColor = Color(0xFFdf5353);

const nagColorMap = {
  1: Colors.lightGreen,
  2: mistakeColor,
  3: Colors.teal,
  4: blunderColor,
  5: Colors.lightBlue,
  6: LichessColors.cyan,
};

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
        color: Colors.lightBlue,
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
