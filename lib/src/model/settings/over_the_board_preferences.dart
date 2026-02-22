import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
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
  OverTheBoardPrefs fromJson(Map<String, dynamic> json) => OverTheBoardPrefs.fromJson(json);

  @override
  OverTheBoardPrefs build() {
    return fetch();
  }

  Future<void> toggleFlipPiecesAfterMove() {
    return save(state.copyWith(flipPiecesAfterMove: !state.flipPiecesAfterMove));
  }

  Future<void> toggleSymmetricPieces() {
    return save(state.copyWith(symmetricPieces: !state.symmetricPieces));
  }

  Future<void> setTimeControlType(TimeControlType type) {
    return save(state.copyWith(timeControlType: type));
  }
}

enum TimeControlType {
  realTime,
  unlimited;

  String label(AppLocalizations l10n) {
    switch (this) {
      case TimeControlType.realTime:
        return l10n.realTime;
      case TimeControlType.unlimited:
        return l10n.unlimited;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class OverTheBoardPrefs with _$OverTheBoardPrefs implements Serializable {
  const OverTheBoardPrefs._();

  const factory OverTheBoardPrefs({
    required bool flipPiecesAfterMove,
    required bool symmetricPieces,
    @Default(TimeControlType.realTime) TimeControlType timeControlType,
  }) = _OverTheBoardPrefs;

  static const defaults = OverTheBoardPrefs(
    flipPiecesAfterMove: false,
    symmetricPieces: false,
    timeControlType: TimeControlType.realTime,
  );

  factory OverTheBoardPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$OverTheBoardPrefsFromJson(json);
    } catch (e) {
      return defaults;
    }
  }
}
