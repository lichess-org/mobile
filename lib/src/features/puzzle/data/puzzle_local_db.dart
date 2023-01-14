import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

import '../model/puzzle.dart';

part 'puzzle_local_db.freezed.dart';
part 'puzzle_local_db.g.dart';

const prefix = 'PuzzleLocalDB';

final puzzleLocalDbProvider = Provider<PuzzleLocalDB>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return PuzzleLocalDB(sharedPrefs);
});

class PuzzleLocalDB {
  const PuzzleLocalDB(this._prefs);

  final SharedPreferences _prefs;

  PuzzleLocalData? fetch({required String userId, required String angle}) {
    final raw = _prefs.getString('$prefix.$userId.$angle');
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException('Expected an object');
      }
      return PuzzleLocalData.fromJson(json);
    }
    return null;
  }

  Future<bool> save(
      {required String userId,
      required String angle,
      required PuzzleLocalData data}) {
    return _prefs.setString(
        '$prefix.$userId.$angle', jsonEncode(data.toJson()));
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
