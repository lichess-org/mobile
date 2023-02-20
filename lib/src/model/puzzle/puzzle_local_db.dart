import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

import 'puzzle.dart';
import 'puzzle_theme.dart';

part 'puzzle_local_db.freezed.dart';
part 'puzzle_local_db.g.dart';

const prefix = 'PuzzleLocalDB';

@Riverpod(keepAlive: true)
PuzzleLocalDB puzzleLocalDB(PuzzleLocalDBRef ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return PuzzleLocalDB(sharedPrefs);
}

class PuzzleLocalDB {
  const PuzzleLocalDB(this._prefs);

  final SharedPreferences _prefs;

  // TODO enum for angle
  PuzzleLocalData? fetch({
    String? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) {
    final raw = _prefs.getString(_makeKey(userId, angle));
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleLocalDB] cannot fetch puzzles: expected an object',
        );
      }
      return PuzzleLocalData.fromJson(json);
    }
    return null;
  }

  Future<bool> save({
    String? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
    required PuzzleLocalData data,
  }) {
    return _prefs.setString(_makeKey(userId, angle), jsonEncode(data.toJson()));
  }

  String _makeKey(String? userId, PuzzleTheme angle) {
    final buffer = StringBuffer();
    buffer.write(prefix);
    if (userId != null) {
      buffer.write('.userId:$userId');
    }
    buffer.write('.angle:${angle.name}');
    return buffer.toString();
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzleLocalData with _$PuzzleLocalData {
  const factory PuzzleLocalData({
    required IList<PuzzleSolution> solved,
    required IList<Puzzle> unsolved,
  }) = _PuzzleLocalData;

  factory PuzzleLocalData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleLocalDataFromJson(json);
}
