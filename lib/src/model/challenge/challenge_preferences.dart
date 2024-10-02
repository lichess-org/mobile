import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_preferences.g.dart';

@riverpod
class ChallengePreferences extends _$ChallengePreferences
    with SessionPreferencesStorage<pref.Challenge> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.Challenge> get prefCategory => pref.Category.challenge;

  @override
  pref.Challenge build() {
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
