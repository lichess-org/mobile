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
  OverTheBoardPrefs fromJson(Map<String, dynamic> json) => OverTheBoardPrefs.fromJson(json);

  @override
  OverTheBoardPrefs build() {
    return fetch();
  }

  Future<void> setMyView(OverTheBoardMyView myView) {
    return save(state.copyWith(myView: myView));
  }

  Future<void> setTimeControlType(TimeControlType type) {
    return save(state.copyWith(timeControlType: type));
  }

  Future<void> setTimeIncrement(TimeIncrement timeIncrement) {
    return save(state.copyWith(timeIncrement: timeIncrement));
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

enum OverTheBoardMyView {
  whiteBottom,
  symmetricPieces,
  flipPieces,
  flipBoard;

  String label(AppLocalizations l10n) => switch(this) {
    whiteBottom => 'White at the bottom',
    symmetricPieces => 'Symmetric pieces',
    flipPieces => 'Flip pieces after move',
    flipBoard => 'Same side (flip board after move)',
  };
}

@Freezed(fromJson: true, toJson: true)
sealed class OverTheBoardPrefs with _$OverTheBoardPrefs implements Serializable {
  const OverTheBoardPrefs._();

  static const _defaultTimeIncrement = TimeIncrement(300, 3);

  const factory OverTheBoardPrefs({
    @Default(OverTheBoardMyView.whiteBottom) OverTheBoardMyView myView,
    @Default(TimeControlType.realTime) TimeControlType timeControlType,
    @Default(OverTheBoardPrefs._defaultTimeIncrement) TimeIncrement timeIncrement,
  }) = _OverTheBoardPrefs;

  static const defaults = OverTheBoardPrefs(
    myView: OverTheBoardMyView.whiteBottom,
    timeControlType: TimeControlType.realTime,
    timeIncrement: _defaultTimeIncrement,
  );

  factory OverTheBoardPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$OverTheBoardPrefsFromJson(json);
    } catch (e) {
      return defaults;
    }
  }
}
