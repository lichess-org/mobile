import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'over_the_board_preferences.freezed.dart';
part 'over_the_board_preferences.g.dart';

final overTheBoardPreferencesProvider =
    NotifierProvider<OverTheBoardPreferencesNotifier, OverTheBoardPrefs>(
      OverTheBoardPreferencesNotifier.new,
      name: 'OverTheBoardPreferencesProvider',
    );

class OverTheBoardPreferencesNotifier extends Notifier<OverTheBoardPrefs>
    with PreferencesStorage<OverTheBoardPrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.overTheBoard;

  @override
  @protected
  OverTheBoardPrefs get defaults => OverTheBoardPrefs.defaults;

  @override
  OverTheBoardPrefs fromJson(Map<String, dynamic> json) {
    final migratedJson = Map<String, dynamic>.of(json);
    if (migratedJson['timeControlType'] == 'realTime' ||
        migratedJson['timeControlType'] == 'increment') {
      migratedJson['timeControlType'] = 'clock';
    }
    if (migratedJson['boardArrangement'] == null) {
      migratedJson['boardArrangement'] = migratedJson['flipPiecesAfterMove'] == true
          ? BoardArrangement.faceToFaceFlipToCurrentPlayer.name
          : BoardArrangement.faceToFaceOpponentUpsideDown.name;
    }
    return OverTheBoardPrefs.fromJson(migratedJson);
  }

  @override
  OverTheBoardPrefs build() {
    return fetch();
  }

  Future<void> setBoardArrangement(BoardArrangement arrangement) =>
      save(state.copyWith(boardArrangement: arrangement));

  Future<void> setTimeControlType(TimeControlType type) {
    return save(state.copyWith(timeControlType: type));
  }

  Future<void> setTimeIncrement(TimeIncrement timeIncrement) {
    return save(state.copyWith(timeIncrement: timeIncrement));
  }

  Future<void> toggleBlindfoldMode() {
    return save(state.copyWith(blindfoldMode: !state.blindfoldMode));
  }
}

enum TimeControlType {
  clock,
  unlimited;

  String label(AppLocalizations l10n) {
    switch (this) {
      case TimeControlType.clock:
        return l10n.clock;
      case TimeControlType.unlimited:
        return l10n.unlimited;
    }
  }
}

/// How the board and pieces are arranged when playing over the board.
///
/// Determines the board orientation and piece facing depending on the seating
/// arrangement (face to face vs. side by side).
enum BoardArrangement {
  /// Players sit across from each other; the opponent's pieces are shown
  /// upside down.
  faceToFaceOpponentUpsideDown,

  /// Players sit across from each other; pieces flip to face the current
  /// player.
  faceToFaceFlipToCurrentPlayer,

  /// Players sit side by side; white stays at the bottom.
  sideBySideWhiteStaysDown,

  /// Players sit side by side; the board rotates to face the current
  /// player.
  sideBySideRotateBoard,
}

@Freezed(fromJson: true, toJson: true)
sealed class OverTheBoardPrefs with _$OverTheBoardPrefs implements Serializable {
  const OverTheBoardPrefs._();

  static const _defaultTimeIncrement = TimeIncrement(300, 3);

  const factory OverTheBoardPrefs({
    required BoardArrangement boardArrangement,
    @Default(TimeControlType.clock) TimeControlType timeControlType,
    @Default(OverTheBoardPrefs._defaultTimeIncrement) TimeIncrement timeIncrement,
    @Default(false) bool blindfoldMode,
  }) = _OverTheBoardPrefs;

  static const defaults = OverTheBoardPrefs(
    boardArrangement: .faceToFaceOpponentUpsideDown,
    timeControlType: TimeControlType.clock,
    timeIncrement: _defaultTimeIncrement,
    blindfoldMode: false,
  );

  factory OverTheBoardPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$OverTheBoardPrefsFromJson(json);
    } catch (e) {
      return defaults;
    }
  }
}
