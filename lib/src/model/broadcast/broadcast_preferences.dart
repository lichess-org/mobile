import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_preferences.freezed.dart';
part 'broadcast_preferences.g.dart';

@riverpod
class BroadcastPreferences extends _$BroadcastPreferences with PreferencesStorage<BroadcastPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.broadcast;

  @override
  BroadcastPrefs build() {
    return fetch();
  }

  Future<void> toggleEvaluationBar() async {
    return save(state.copyWith(showEvaluationBar: !state.showEvaluationBar));
  }
}

@Freezed(fromJson: true, toJson: true)
class BroadcastPrefs with _$BroadcastPrefs implements SerializablePreferences {
  const factory BroadcastPrefs({
    required bool showEvaluationBar,
  }) = _BroadcastPrefs;

  static const defaults = BroadcastPrefs(
        showEvaluationBar: true,
      );

  factory BroadcastPrefs.fromJson(Map<String, dynamic> json) =>
      _$BroadcastPrefsFromJson(json);
}
