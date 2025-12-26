import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:logging/logging.dart';

part 'log_preferences.freezed.dart';
part 'log_preferences.g.dart';

final logPreferencesProvider = NotifierProvider<LogPreferencesNotifier, LogPrefs>(
  LogPreferencesNotifier.new,
  name: 'LogPreferencesProvider',
);

class LogPreferencesNotifier extends Notifier<LogPrefs> with PreferencesStorage<LogPrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.overTheBoard;

  @override
  @protected
  LogPrefs get defaults => LogPrefs.defaults;

  @override
  LogPrefs fromJson(Map<String, dynamic> json) => LogPrefs.fromJson(json);

  @override
  LogPrefs build() => fetch();

  Future<void> setLogLevel(Level level) {
    return save(state.copyWith(level: level));
  }
}

const _kDefaultLevel = kDebugMode ? Level.FINE : Level.OFF;

@Freezed(fromJson: true, toJson: true)
sealed class LogPrefs with _$LogPrefs implements Serializable {
  const LogPrefs._();

  const factory LogPrefs({@LevelConverter() required Level level}) = _LogPrefs;

  static const defaults = LogPrefs(level: _kDefaultLevel);

  factory LogPrefs.fromJson(Map<String, dynamic> json) {
    return _$LogPrefsFromJson(json);
  }
}

class LevelConverter implements JsonConverter<Level, String> {
  const LevelConverter();

  @override
  Level fromJson(String json) {
    try {
      final value = int.parse(json);
      return Level.LEVELS.firstWhere((level) => level.value == value);
    } catch (e) {
      return _kDefaultLevel;
    }
  }

  @override
  String toJson(Level object) => object.value.toString();
}
