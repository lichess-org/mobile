import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/local_game_clock.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'offline_computer_game_preferences.freezed.dart';
part 'offline_computer_game_preferences.g.dart';

final offlineComputerGamePreferencesProvider =
    NotifierProvider<OfflineComputerGamePreferences, OfflineComputerGamePrefs>(
      OfflineComputerGamePreferences.new,
      name: 'OfflineComputerGamePreferencesProvider',
    );

class OfflineComputerGamePreferences()
    extends Notifier<OfflineComputerGamePrefs>
    with PreferencesStorage<OfflineComputerGamePrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.offlineComputerGame;

  @override
  OfflineComputerGamePrefs get defaults => OfflineComputerGamePrefs.defaults;

  @override
  OfflineComputerGamePrefs fromJson(Map<String, dynamic> json) =>
      OfflineComputerGamePrefs.fromJson(json);

  @override
  OfflineComputerGamePrefs build() {
    return fetch();
  }

  Future<void> setOpponent(OpponentSpec opponent) {
    return save(state.copyWith(opponentSpec: opponent));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return save(state.copyWith(sideChoice: sideChoice));
  }

  Future<void> setVariant(Variant variant) {
    return save(state.copyWith(variant: variant));
  }

  Future<void> setCasual(bool casual) {
    return save(state.copyWith(casual: casual));
  }

  Future<void> setPracticeMode(bool practiceMode) {
    return save(state.copyWith(practiceMode: practiceMode));
  }

  Future<void> setTimeControlType(TimeControlType type) {
    return save(state.copyWith(timeControlType: type));
  }

  Future<void> setTimeIncrement(TimeIncrement timeIncrement) {
    return save(state.copyWith(timeIncrement: timeIncrement));
  }

  Future<void> toggleHideBestMove() {
    return save(state.copyWith(hideBestMove: !state.hideBestMove));
  }

  Future<void> toggleHideEvaluation() {
    return save(state.copyWith(hideEvaluation: !state.hideEvaluation));
  }

  Future<void> toggleBlindfoldMode() {
    return save(state.copyWith(blindfoldMode: !state.blindfoldMode));
  }
}

/// Represents the player's color choice for offline computer games.
enum SideChoice() {
  white,
  random,
  black,
  nextToPlay;

  /// Resolves the side choice to a [Side].
  ///
  /// When [fen] is provided and this is [nextToPlay], returns the side to move
  /// from the FEN. Returns `null` for [random] (caller should pick randomly).
  Side? toSide({String? fen}) => switch (this) {
    SideChoice.white => Side.white,
    SideChoice.random => null,
    SideChoice.black => Side.black,
    SideChoice.nextToPlay => fen != null ? Setup.parseFen(fen).turn : null,
  };

  static SideChoice fromSide(Side? side) => switch (side) {
    Side.white => SideChoice.white,
    Side.black => SideChoice.black,
    null => SideChoice.random,
  };
}

@Freezed(fromJson: true, toJson: true)
sealed class const OfflineComputerGamePrefs._()
    with _$OfflineComputerGamePrefs
    implements Serializable {
  /// The time control a game falls back to when the player asks for a clock without having picked
  /// one yet.
  static const defaultClockTimeIncrement = TimeIncrement(300, 3);

  const factory({
    @JsonKey(readValue: readOpponent) required OpponentSpec opponentSpec,
    required SideChoice sideChoice,
    @Default(Variant.standard) Variant variant,
    @Default(true) bool casual,
    @Default(false) bool practiceMode,
    @Default(TimeControlType.unlimited) TimeControlType timeControlType,
    @Default(TimeIncrement.infinite()) TimeIncrement timeIncrement,
    @Default(false) bool hideBestMove,
    @Default(false) bool hideEvaluation,
    @Default(false) bool blindfoldMode,
  }) = _OfflineComputerGamePrefs;

  static const defaults = OfflineComputerGamePrefs(
    opponentSpec: StockfishOpponentSpec(StockfishLevel.defaultLevel),
    sideChoice: SideChoice.random,
    variant: Variant.standard,
    casual: true,
    practiceMode: false,
    timeControlType: TimeControlType.unlimited,
    timeIncrement: TimeIncrement.infinite(),
    hideBestMove: false,
    hideEvaluation: false,
    blindfoldMode: false,
  );

  factory fromJson(Map<String, dynamic> json) {
    try {
      return _$OfflineComputerGamePrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
