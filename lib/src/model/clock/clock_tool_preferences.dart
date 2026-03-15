import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'clock_tool_preferences.freezed.dart';
part 'clock_tool_preferences.g.dart';

final clockToolPreferencesProvider =
    NotifierProvider<ClockToolPreferencesNotifier, ClockToolPrefs>(
      ClockToolPreferencesNotifier.new,
    );

class ClockToolPreferencesNotifier extends Notifier<ClockToolPrefs>
    with PreferencesStorage<ClockToolPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.clockTool;

  @override
  @protected
  ClockToolPrefs get defaults => ClockToolPrefs.defaults;

  @override
  ClockToolPrefs fromJson(Map<String, dynamic> json) => ClockToolPrefs.fromJson(json);

  @override
  ClockToolPrefs build() => fetch();

  Future<void> setLowTimeWarning(LowTimeWarning warning) {
    return save(state.copyWith(lowTimeWarning: warning));
  }
}

enum LowTimeWarning {
  off,
  tenPercent,
  tenSeconds,
  twentySeconds,
  thirtySeconds;

  // TODO: translate
  String get label => switch (this) {
    .off => 'Off',
    .tenPercent => '10%',
    .tenSeconds => '10s',
    .twentySeconds => '20s',
    .thirtySeconds => '30s',
  };

  /// Returns the warning threshold given the player's [initialTime],
  /// or null if the warning is disabled.
  Duration? threshold(Duration initialTime) => switch (this) {
    .off => null,
    .tenPercent => initialTime > Duration.zero
        ? Duration(milliseconds: initialTime.inMilliseconds ~/ 10)
        : null,
    .tenSeconds => const Duration(seconds: 10),
    .twentySeconds => const Duration(seconds: 20),
    .thirtySeconds => const Duration(seconds: 30),
  };
}

@Freezed(fromJson: true, toJson: true)
sealed class ClockToolPrefs with _$ClockToolPrefs implements Serializable {
  const ClockToolPrefs._();

  const factory ClockToolPrefs({
    @JsonKey(
      unknownEnumValue: LowTimeWarning.tenPercent,
      defaultValue: LowTimeWarning.tenPercent,
    )
    required LowTimeWarning lowTimeWarning,
  }) = _ClockToolPrefs;

  static const defaults = ClockToolPrefs(lowTimeWarning: LowTimeWarning.tenPercent);

  factory ClockToolPrefs.fromJson(Map<String, dynamic> json) =>
      _$ClockToolPrefsFromJson(json);
}
