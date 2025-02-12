import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_preferences.freezed.dart';
part 'broadcast_preferences.g.dart';

@Riverpod(keepAlive: true)
class BroadcastPreferences extends _$BroadcastPreferences with PreferencesStorage<BroadcastPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  PrefCategory get prefCategory => PrefCategory.broadcast;

  // ignore: avoid_public_notifier_properties
  @override
  BroadcastPrefs get defaults => BroadcastPrefs.defaults;

  @override
  BroadcastPrefs fromJson(Map<String, dynamic> json) => BroadcastPrefs.fromJson(json);

  @override
  BroadcastPrefs build() {
    return fetch();
  }

  Future<void> toggleEvaluationBar() async {
    return save(state.copyWith(showEvaluationBar: !state.showEvaluationBar));
  }
}

@Freezed(fromJson: true, toJson: true)
class BroadcastPrefs with _$BroadcastPrefs implements Serializable {
  const factory BroadcastPrefs({required bool showEvaluationBar}) = _BroadcastPrefs;

  static const defaults = BroadcastPrefs(showEvaluationBar: true);

  factory BroadcastPrefs.fromJson(Map<String, dynamic> json) => _$BroadcastPrefsFromJson(json);
}
