import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'offline_computer_game_preferences.freezed.dart';
part 'offline_computer_game_preferences.g.dart';

final offlineComputerGamePreferencesProvider =
    NotifierProvider<OfflineComputerGamePreferences, OfflineComputerGamePrefs>(
      OfflineComputerGamePreferences.new,
      name: 'OfflineComputerGamePreferencesProvider',
    );

class OfflineComputerGamePreferences extends Notifier<OfflineComputerGamePrefs>
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

  Future<void> setStockfishLevel(StockfishLevel level) {
    return save(state.copyWith(stockfishLevel: level));
  }

  Future<void> setSideChoice(SideChoice sideChoice) {
    return save(state.copyWith(sideChoice: sideChoice));
  }

  Future<void> setCasual(bool casual) {
    return save(state.copyWith(casual: casual));
  }
}

/// Represents the player's color choice for offline computer games.
enum SideChoice {
  white,
  random,
  black;

  Side? toSide() => switch (this) {
    SideChoice.white => Side.white,
    SideChoice.random => null,
    SideChoice.black => Side.black,
  };

  static SideChoice fromSide(Side? side) => switch (side) {
    Side.white => SideChoice.white,
    Side.black => SideChoice.black,
    null => SideChoice.random,
  };
}

@Freezed(fromJson: true, toJson: true)
sealed class OfflineComputerGamePrefs with _$OfflineComputerGamePrefs implements Serializable {
  const OfflineComputerGamePrefs._();

  const factory OfflineComputerGamePrefs({
    required StockfishLevel stockfishLevel,
    required SideChoice sideChoice,
    @Default(true) bool casual,
  }) = _OfflineComputerGamePrefs;

  static const defaults = OfflineComputerGamePrefs(
    stockfishLevel: StockfishLevel.defaultLevel,
    sideChoice: SideChoice.random,
    casual: true,
  );

  factory OfflineComputerGamePrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$OfflineComputerGamePrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
