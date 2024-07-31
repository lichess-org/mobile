import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'opening_explorer_preferences.freezed.dart';
part 'opening_explorer_preferences.g.dart';

@Riverpod(keepAlive: true)
class OpeningExplorerPreferences extends _$OpeningExplorerPreferences {
  static const prefKey = 'preferences.opening_explorer';

  @override
  OpeningExplorerPrefState build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final stored = prefs.getString(prefKey);
    return stored != null
        ? OpeningExplorerPrefState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : OpeningExplorerPrefState.defaults;
  }

  Future<void> setDatabase(OpeningDatabase db) => _save(
        state.copyWith(db: db),
      );

  Future<void> setMasterDbSince(int year) =>
      _save(state.copyWith(masterDb: state.masterDb.copyWith(sinceYear: year)));

  Future<void> setMasterDbUntil(int year) =>
      _save(state.copyWith(masterDb: state.masterDb.copyWith(untilYear: year)));

  Future<void> toggleLichessDbSpeed(Perf speed) => _save(
        state.copyWith(
          lichessDb: state.lichessDb.copyWith(
            speeds: state.lichessDb.speeds.contains(speed)
                ? state.lichessDb.speeds.remove(speed)
                : state.lichessDb.speeds.add(speed),
          ),
        ),
      );

  Future<void> toggleLichessDbRating(int rating) => _save(
        state.copyWith(
          lichessDb: state.lichessDb.copyWith(
            ratings: state.lichessDb.ratings.contains(rating)
                ? state.lichessDb.ratings.remove(rating)
                : state.lichessDb.ratings.add(rating),
          ),
        ),
      );

  Future<void> setLichessDbSince(DateTime since) => _save(
        state.copyWith(lichessDb: state.lichessDb.copyWith(since: since)),
      );

  Future<void> setLichessDbUntil(DateTime until) => _save(
        state.copyWith(lichessDb: state.lichessDb.copyWith(until: until)),
      );

  Future<void> _save(OpeningExplorerPrefState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

enum OpeningDatabase {
  master,
  lichess,
}

@Freezed(fromJson: true, toJson: true)
class OpeningExplorerPrefState with _$OpeningExplorerPrefState {
  const OpeningExplorerPrefState._();

  const factory OpeningExplorerPrefState({
    required OpeningDatabase db,
    required MasterDbPrefState masterDb,
    required LichessDbPrefState lichessDb,
  }) = _OpeningExplorerPrefState;

  static final defaults = OpeningExplorerPrefState(
    db: OpeningDatabase.master,
    masterDb: MasterDbPrefState.defaults,
    lichessDb: LichessDbPrefState.defaults,
  );

  factory OpeningExplorerPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$OpeningExplorerPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class MasterDbPrefState with _$MasterDbPrefState {
  const MasterDbPrefState._();

  const factory MasterDbPrefState({
    required int sinceYear,
    required int untilYear,
  }) = _MasterDbPrefState;

  static const earliestYear = 1952;
  static final defaults = MasterDbPrefState(
    sinceYear: earliestYear,
    untilYear: DateTime.now().year,
  );

  factory MasterDbPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$MasterDbPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class LichessDbPrefState with _$LichessDbPrefState {
  const LichessDbPrefState._();

  const factory LichessDbPrefState({
    required ISet<Perf> speeds,
    required ISet<int> ratings,
    required DateTime since,
    required DateTime until,
  }) = _LichessDbPrefState;

  static const availableSpeeds = ISetConst({
    Perf.ultraBullet,
    Perf.bullet,
    Perf.blitz,
    Perf.rapid,
    Perf.classical,
    Perf.correspondence,
  });
  static const availableRatings = ISetConst({
    0,
    1000,
    1200,
    1400,
    1600,
    1800,
    2000,
    2200,
    2500,
  });
  static final earliestDate = DateTime.parse('2012-12-01');
  static final defaults = LichessDbPrefState(
    speeds: availableSpeeds,
    ratings: availableRatings,
    since: earliestDate,
    until: DateTime.now(),
  );

  factory LichessDbPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$LichessDbPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
