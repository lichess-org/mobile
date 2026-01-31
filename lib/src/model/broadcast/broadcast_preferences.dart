import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'broadcast_preferences.freezed.dart';
part 'broadcast_preferences.g.dart';

final broadcastPreferencesProvider = NotifierProvider<BroadcastPreferences, BroadcastPrefs>(
  BroadcastPreferences.new,
  name: 'BroadcastPreferencesProvider',
);

class BroadcastPreferences extends Notifier<BroadcastPrefs>
    with PreferencesStorage<BroadcastPrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.broadcast;

  @override
  @protected
  BroadcastPrefs get defaults => BroadcastPrefs.defaults;

  @override
  BroadcastPrefs fromJson(Map<String, dynamic> json) => BroadcastPrefs.fromJson(json);

  @override
  BroadcastPrefs build() {
    return fetch();
  }

  Future<void> toggleEvaluationBar() {
    return save(state.copyWith(showRoundEvaluationGauges: !state.showRoundEvaluationGauges));
  }

  Future<void> toggleServerAnalysis() {
    return save(state.copyWith(enableServerAnalysis: !state.enableServerAnalysis));
  }

  Future<void> toggleShowEvaluationGauge() {
    return save(state.copyWith(showEvaluationGauge: !state.showEvaluationGauge));
  }

  Future<void> toggleShowEngineLines() {
    return save(state.copyWith(showEngineLines: !state.showEngineLines));
  }

  Future<void> toggleAnnotations() {
    return save(state.copyWith(showAnnotations: !state.showAnnotations));
  }

  Future<void> togglePgnComments() {
    return save(state.copyWith(showPgnComments: !state.showPgnComments));
  }

  Future<void> toggleShowBestMoveArrow() {
    return save(state.copyWith(showBestMoveArrow: !state.showBestMoveArrow));
  }

  Future<void> toggleInlineNotation() {
    return save(state.copyWith(inlineNotation: !state.inlineNotation));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class BroadcastPrefs with _$BroadcastPrefs implements Serializable, CommonAnalysisPrefs {
  const factory BroadcastPrefs({
    @JsonKey(defaultValue: true) required bool showRoundEvaluationGauges,
    @JsonKey(defaultValue: true) required bool enableServerAnalysis,
    @JsonKey(defaultValue: true) required bool showEvaluationGauge,
    @JsonKey(defaultValue: true) required bool showEngineLines,
    @JsonKey(defaultValue: true) required bool showBestMoveArrow,
    @JsonKey(defaultValue: true) required bool showAnnotations,
    @JsonKey(defaultValue: true) required bool showPgnComments,
    @JsonKey(defaultValue: false) required bool inlineNotation,
  }) = _BroadcastPrefs;

  static const defaults = BroadcastPrefs(
    showRoundEvaluationGauges: true,
    enableServerAnalysis: true,
    showEvaluationGauge: true,
    showEngineLines: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    inlineNotation: false,
  );

  factory BroadcastPrefs.fromJson(Map<String, dynamic> json) => _$BroadcastPrefsFromJson(json);
}
