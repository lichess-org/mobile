import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_preferences.freezed.dart';
part 'challenge_preferences.g.dart';

@Riverpod(keepAlive: true)
class ChallengePreferences extends _$ChallengePreferences {
  static String _prefKey(AuthSessionState? session) =>
      'preferences.game_setup.${session?.user.id ?? '**anon**'}';

  @override
  ChallengePreferencesState build() {
    final session = ref.watch(authSessionProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey(session));
    return stored != null
        ? ChallengePreferencesState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : ChallengePreferencesState.defaults;
  }

  Future<void> setVariant(Variant variant) {
    return _save(state.copyWith(variant: variant));
  }

  Future<void> setTimeControl(ChallengeTimeControlType timeControl) {
    return _save(state.copyWith(timeControl: timeControl));
  }

  Future<void> setClock(Duration time, Duration increment) {
    return _save(state.copyWith(clock: (time: time, increment: increment)));
  }

  Future<void> setDays(int days) {
    return _save(state.copyWith(days: days));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return _save(state.copyWith(sideChoice: sideChoice));
  }

  Future<void> setRated(bool rated) {
    return _save(state.copyWith(rated: rated));
  }

  Future<void> _save(ChallengePreferencesState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final session = ref.read(authSessionProvider);
    await prefs.setString(
      _prefKey(session),
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class ChallengePreferencesState with _$ChallengePreferencesState {
  const ChallengePreferencesState._();

  const factory ChallengePreferencesState({
    required Variant variant,
    required ChallengeTimeControlType timeControl,
    required ({Duration time, Duration increment}) clock,
    required int days,
    required bool rated,
    required SideChoice sideChoice,
  }) = _ChallengeSetup;

  static const defaults = ChallengePreferencesState(
    variant: Variant.standard,
    timeControl: ChallengeTimeControlType.clock,
    clock: (time: Duration(minutes: 10), increment: Duration.zero),
    days: 3,
    rated: false,
    sideChoice: SideChoice.random,
  );

  Speed get speed => timeControl == ChallengeTimeControlType.clock
      ? Speed.fromTimeIncrement(
          TimeIncrement(
            clock.time.inSeconds,
            clock.increment.inSeconds,
          ),
        )
      : Speed.correspondence;

  factory ChallengePreferencesState.fromJson(Map<String, dynamic> json) {
    try {
      return _$ChallengePreferencesStateFromJson(json);
    } catch (_) {
      return ChallengePreferencesState.defaults;
    }
  }
}
