import 'dart:convert';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';

part 'user_screen_preferences.freezed.dart';
part 'user_screen_preferences.g.dart';

const _prefKey = 'preferences.user_screen';

@Riverpod(keepAlive: true)
class UserScreenPreferences extends _$UserScreenPreferences {
  @override
  UserScreenPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? UserScreenPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const UserScreenPrefs(
            perfOrder: [
              Perf.bullet,
              Perf.blitz,
              Perf.rapid,
              Perf.classical,
              Perf.correspondence,
              Perf.puzzle,
              Perf.storm,
              Perf.ultraBullet,
              Perf.antichess,
              Perf.atomic,
              Perf.chess960,
              Perf.crazyhouse,
              Perf.fromPosition,
              Perf.horde,
              Perf.kingOfTheHill,
              Perf.racingKings,
              Perf.threeCheck
            ],
          );
  }

  Future<void> setPerfOrder(List<Perf> perfOrder) {
    return _save(state.copyWith(perfOrder: perfOrder));
  }

  Future<void> _save(UserScreenPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class UserScreenPrefs with _$UserScreenPrefs {
  const factory UserScreenPrefs({
    required List<Perf> perfOrder,
  }) = _UserScreenPrefs;

  factory UserScreenPrefs.fromJson(Map<String, dynamic> json) =>
      _$UserScreenPrefsFromJson(json);
}
