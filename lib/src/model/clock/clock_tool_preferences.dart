import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'clock_tool_preferences.freezed.dart';
part 'clock_tool_preferences.g.dart';

final clockToolPreferencesProvider = NotifierProvider<ClockToolPreferences, ClockToolPrefs>(
  ClockToolPreferences.new,
  name: 'ClockToolPreferencesProvider',
);

class ClockToolPreferences extends Notifier<ClockToolPrefs>
    with SessionPreferencesStorage<ClockToolPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.clockTool;

  @override
  ClockToolPrefs defaults({LightUser? user}) => ClockToolPrefs.defaults;

  @override
  ClockToolPrefs fromJson(Map<String, dynamic> json) => ClockToolPrefs.fromJson(json);

  @override
  ClockToolPrefs build() {
    return fetch();
  }

  Future<void> setTimeIncrement(TimeIncrement timeIncrement) {
    return save(state.copyWith(timeIncrement: timeIncrement));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class ClockToolPrefs with _$ClockToolPrefs implements Serializable {
  const ClockToolPrefs._();

  const factory ClockToolPrefs({required TimeIncrement timeIncrement}) = _ClockToolPrefs;

  static const defaults = ClockToolPrefs(timeIncrement: TimeIncrement(600, 0));

  factory ClockToolPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$ClockToolPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
