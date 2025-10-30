import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_preferences.freezed.dart';
part 'broadcast_preferences.g.dart';

@Riverpod(keepAlive: true)
class BroadcastPreferences extends _$BroadcastPreferences
    with PreferencesStorage<BroadcastPrefs> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.broadcast;

  @override
  @protected
  BroadcastPrefs get defaults => BroadcastPrefs.defaults;

  @override
  BroadcastPrefs fromJson(Map<String, dynamic> json) =>
      BroadcastPrefs.fromJson(json);

  @override
  BroadcastPrefs build() {
    return fetch();
  }

  Future<void> toggleEvaluationBar() {
    return save(state.copyWith(showEvaluationBar: !state.showEvaluationBar));
  }

  Future<void> toggleServerAnalysis() {
    return save(
      state.copyWith(enableServerAnalysis: !state.enableServerAnalysis),
    );
  }

  Future<void> toggleShowEvaluationGauge() {
    return save(
      state.copyWith(showEvaluationGauge: !state.showEvaluationGauge),
    );
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

  Future<void> toggleSmallBoard() {
    return save(state.copyWith(smallBoard: !state.smallBoard));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class BroadcastPrefs
    with _$BroadcastPrefs
    implements Serializable, CommonAnalysisPrefs {
  const factory BroadcastPrefs({
    required bool showEvaluationBar,
    @JsonKey(defaultValue: true) required bool enableServerAnalysis,
    @JsonKey(defaultValue: true) required bool showEvaluationGauge,
    @JsonKey(defaultValue: true) required bool showEngineLines,
    @JsonKey(defaultValue: true) required bool showBestMoveArrow,
    @JsonKey(defaultValue: true) required bool showAnnotations,
    @JsonKey(defaultValue: true) required bool showPgnComments,
    @JsonKey(defaultValue: false) required bool inlineNotation,
    @JsonKey(defaultValue: false) required bool smallBoard,
  }) = _BroadcastPrefs;

  static const defaults = BroadcastPrefs(
    showEvaluationBar: true,
    enableServerAnalysis: true,
    showEvaluationGauge: true,
    showEngineLines: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    inlineNotation: false,
    smallBoard: false,
  );

  factory BroadcastPrefs.fromJson(Map<String, dynamic> json) =>
      _$BroadcastPrefsFromJson(json);
}
