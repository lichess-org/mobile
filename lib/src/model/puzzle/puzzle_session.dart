import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'puzzle_session.freezed.dart';
part 'puzzle_session.g.dart';

final puzzleSessionProvider =
    NotifierProvider.family<PuzzleSession, PuzzleSessionData, PuzzleSessionParams>(
      PuzzleSession.new,
      name: 'PuzzleSessionProvider',
    );

typedef PuzzleSessionParams = ({UserId? userId, PuzzleAngle angle});

class PuzzleSession extends Notifier<PuzzleSessionData> {
  PuzzleSession(this.params);

  final PuzzleSessionParams params;

  static const maxAge = Duration(hours: 1);
  static const maxSize = 150;

  @override
  PuzzleSessionData build() {
    final data = _stored;
    if (data != null &&
        data.angle == params.angle &&
        data.lastUpdatedAt.isAfter(DateTime.now().subtract(maxAge))) {
      return data;
    }
    return PuzzleSessionData.initial(angle: params.angle);
  }

  Future<void> addAttempt(PuzzleId id, {required bool win}) async {
    await _update((d) {
      final newAttempts = d.attempts.replaceFirstWhere(
        (p) => p.id == id,
        (p) => p?.copyWith(win: win) ?? PuzzleAttempt(id: id, win: win),
        addIfNotFound: true,
      );
      final newState = d.copyWith(
        attempts: newAttempts.length > maxSize ? newAttempts.sublist(1) : newAttempts,
        lastUpdatedAt: DateTime.now(),
      );
      state = newState;
      return newState;
    });
  }

  Future<void> setRatingDiffs(Iterable<PuzzleRound> rounds) async {
    await _update((d) {
      final newState = d.copyWith(
        attempts: d.attempts.map((a) {
          final round = rounds.firstWhereOrNull((r) => r.id == a.id);
          return round != null ? a.copyWith(ratingDiff: round.ratingDiff) : a;
        }).toIList(),
      );
      state = newState;
      return newState;
    });
  }

  Future<void> _update(PuzzleSessionData Function(PuzzleSessionData d) update) async {
    await _store.setString(_storageKey, jsonEncode(update(state).toJson()));
  }

  PuzzleSessionData? get _stored {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return PuzzleSessionData.initial(angle: params.angle);
    }
    return PuzzleSessionData.fromJson(jsonDecode(stored) as Map<String, dynamic>);
  }

  SharedPreferencesWithCache get _store => LichessBinding.instance.sharedPreferences;

  String get _storageKey => 'puzzle_session.${params.userId ?? '**anon**'}';
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleSessionData with _$PuzzleSessionData {
  const factory PuzzleSessionData({
    required PuzzleAngle angle,
    required IList<PuzzleAttempt> attempts,
    required DateTime lastUpdatedAt,
  }) = _PuzzleSession;

  factory PuzzleSessionData.initial({required PuzzleAngle angle}) {
    return PuzzleSessionData(
      angle: angle,
      attempts: IList(const []),
      lastUpdatedAt: DateTime.now(),
    );
  }

  factory PuzzleSessionData.fromJson(Map<String, dynamic> json) {
    try {
      return _$PuzzleSessionDataFromJson(json);
    } catch (e) {
      return PuzzleSessionData.initial(angle: const PuzzleTheme(PuzzleThemeKey.mix));
    }
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleAttempt with _$PuzzleAttempt {
  const PuzzleAttempt._();

  const factory PuzzleAttempt({required PuzzleId id, required bool win, int? ratingDiff}) =
      _PuzzleAttempt;

  factory PuzzleAttempt.fromJson(Map<String, dynamic> json) => _$PuzzleAttemptFromJson(json);

  String? get ratingDiffString {
    if (ratingDiff == null) return null;
    final prefix = ratingDiff! >= 0 ? '+' : '';
    return '$prefix${ratingDiff!}';
  }
}
