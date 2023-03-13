import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart'
//     hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

part 'puzzle_session_view_model.g.dart';

@riverpod
class PuzzleSessionViewModel extends _$PuzzleSessionViewModel {
  static const maxAge = Duration(hours: 1);
  static const maxSize = 50;

  @override
  PuzzleSession build(UserId? userId, PuzzleTheme theme) {
    // return PuzzleSession(
    //   theme: theme,
    //   attempts: IList(List.generate(
    //     50,
    //     (i) => PuzzleAttempt(
    //       id: PuzzleId('id$i'),
    //       win: i % 2 == 0,
    //       ratingDiff: i,
    //     ),
    //   )),
    //   lastUpdatedAt: DateTime.now(),
    // );

    final data = _stored;
    if (data != null &&
        data.theme == theme &&
        data.lastUpdatedAt.isAfter(DateTime.now().subtract(maxAge))) {
      return data;
    }
    return PuzzleSession.initial(theme: theme);
  }

  Future<void> addAttempt(PuzzleId id, {required bool win}) async {
    await _update((d) {
      final newAttempts = d.attempts.replaceFirstWhere(
        (p) => p.id == id,
        (p) => p?.copyWith(win: win) ?? PuzzleAttempt(id: id, win: win),
        addIfNotFound: true,
      );
      final newState = d.copyWith(
        attempts:
            newAttempts.length > maxSize ? newAttempts.sublist(1) : newAttempts,
        lastUpdatedAt: DateTime.now(),
      );
      state = newState;
      return newState;
    });
  }

  Future<void> setRatingDiff(PuzzleId id, int ratingDiff) async {
    await _update((d) {
      final index = d.attempts.indexWhere((p) => p.id == id);
      if (index == -1) {
        return d;
      } else {
        final newState = d.copyWith(
          attempts: d.attempts.replace(
            index,
            d.attempts[index].copyWith(ratingDiff: ratingDiff),
          ),
        );
        state = newState;
        return newState;
      }
    });
  }

  Future<void> _update(
    PuzzleSession Function(PuzzleSession d) update,
  ) async {
    await _store.setString(_storageKey, jsonEncode((update(state)).toJson()));
  }

  PuzzleSession? get _stored {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return PuzzleSession.initial(theme: theme);
    }
    return PuzzleSession.fromJson(
      jsonDecode(stored) as Map<String, dynamic>,
    );
  }

  SharedPreferences get _store => ref.read(sharedPreferencesProvider);
  String get _storageKey => 'puzzle_session.${userId ?? 'anon'}';
}
