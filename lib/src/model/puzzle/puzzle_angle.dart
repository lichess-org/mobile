import 'package:freezed_annotation/freezed_annotation.dart';

part 'puzzle_angle.freezed.dart';

sealed class PuzzleAngle {
  String get key;
}

@freezed
class PuzzleTheme with _$PuzzleTheme implements PuzzleAngle {
  const factory PuzzleTheme(String key) = _PuzzleTheme;
}

@freezed
class PuzzleOpening with _$PuzzleOpening implements PuzzleAngle {
  const factory PuzzleOpening(String key) = _PuzzleOpening;
}
