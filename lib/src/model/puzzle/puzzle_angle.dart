import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

part 'puzzle_angle.freezed.dart';

sealed class PuzzleAngle {
  String get key;
  String toJson();

  static PuzzleAngle fromKey(String key) {
    final theme = puzzleThemeNameMap.get(key);
    if (theme != null) {
      return PuzzleTheme(theme);
    } else {
      return PuzzleOpening(key);
    }
  }

  factory PuzzleAngle.fromJson(dynamic json) {
    return fromKey(json as String);
  }
}

@freezed
sealed class PuzzleTheme with _$PuzzleTheme implements PuzzleAngle {
  const PuzzleTheme._();
  const factory PuzzleTheme(PuzzleThemeKey themeKey) = _PuzzleTheme;

  @override
  String get key => themeKey.name;

  @override
  String toJson() => key;
}

@freezed
sealed class PuzzleOpening with _$PuzzleOpening implements PuzzleAngle {
  const PuzzleOpening._();
  const factory PuzzleOpening(String key) = _PuzzleOpening;

  @override
  String toJson() => key;
}
