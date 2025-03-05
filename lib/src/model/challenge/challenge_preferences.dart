import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_preferences.freezed.dart';
part 'challenge_preferences.g.dart';

@Riverpod(keepAlive: true)
class ChallengePreferences extends _$ChallengePreferences
    with SessionPreferencesStorage<ChallengePrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.challenge;

  @override
  ChallengePrefs defaults({LightUser? user}) => ChallengePrefs.defaults;

  @override
  ChallengePrefs fromJson(Map<String, dynamic> json) => ChallengePrefs.fromJson(json);

  @override
  ChallengePrefs build() {
    return fetch();
  }

  Future<void> setVariant(Variant variant) {
    return save(state.copyWith(variant: variant));
  }

  Future<void> setTimeControl(ChallengeTimeControlType timeControl) {
    return save(state.copyWith(timeControl: timeControl));
  }

  Future<void> setClock(Duration time, Duration increment) {
    return save(state.copyWith(clock: (time: time, increment: increment)));
  }

  Future<void> setDays(int days) {
    return save(state.copyWith(days: days));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return save(state.copyWith(sideChoice: sideChoice));
  }

  Future<void> setRated(bool rated) {
    return save(state.copyWith(rated: rated));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class ChallengePrefs with _$ChallengePrefs implements Serializable {
  const ChallengePrefs._();

  const factory ChallengePrefs({
    required Variant variant,
    required ChallengeTimeControlType timeControl,
    required ({Duration time, Duration increment}) clock,
    required int days,
    required bool rated,
    required SideChoice sideChoice,
  }) = _ChallengePrefs;

  static const defaults = ChallengePrefs(
    variant: Variant.standard,
    timeControl: ChallengeTimeControlType.clock,
    clock: (time: Duration(minutes: 10), increment: Duration.zero),
    days: 3,
    rated: false,
    sideChoice: SideChoice.random,
  );

  Speed get speed =>
      timeControl == ChallengeTimeControlType.clock
          ? Speed.fromTimeIncrement(TimeIncrement(clock.time.inSeconds, clock.increment.inSeconds))
          : Speed.correspondence;

  ChallengeRequest makeRequest(LightUser destUser, [String? initialFen]) {
    return ChallengeRequest(
      destUser: destUser,
      variant: variant,
      timeControl: timeControl,
      clock: timeControl == ChallengeTimeControlType.clock ? clock : null,
      days: timeControl == ChallengeTimeControlType.correspondence ? days : null,
      rated: rated,
      sideChoice: sideChoice,
      initialFen: initialFen,
    );
  }

  factory ChallengePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$ChallengePrefsFromJson(json);
    } catch (_) {
      return ChallengePrefs.defaults;
    }
  }
}
