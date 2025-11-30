import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';

part 'analysis_preferences.freezed.dart';
part 'analysis_preferences.g.dart';

final analysisPreferencesProvider = NotifierProvider<AnalysisPreferences, AnalysisPrefs>(
  AnalysisPreferences.new,
  name: 'AnalysisPreferencesProvider',
);

class AnalysisPreferences extends Notifier<AnalysisPrefs> with PreferencesStorage<AnalysisPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.analysis;

  @override
  @protected
  AnalysisPrefs get defaults => AnalysisPrefs.defaults;

  @override
  AnalysisPrefs fromJson(Map<String, dynamic> json) => AnalysisPrefs.fromJson(json);

  @override
  AnalysisPrefs build() {
    return fetch();
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
sealed class AnalysisPrefs with _$AnalysisPrefs implements Serializable, CommonAnalysisPrefs {
  const AnalysisPrefs._();

  const factory AnalysisPrefs({
    @JsonKey(defaultValue: true) required bool enableServerAnalysis,
    required bool showEvaluationGauge,
    @JsonKey(defaultValue: true) required bool showEngineLines,
    required bool showBestMoveArrow,
    required bool showAnnotations,
    required bool showPgnComments,
    @JsonKey(defaultValue: false) required bool inlineNotation,
  }) = _AnalysisPrefs;

  static const defaults = AnalysisPrefs(
    enableServerAnalysis: true,
    showEvaluationGauge: true,
    showEngineLines: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    inlineNotation: false,
  );

  factory AnalysisPrefs.fromJson(Map<String, dynamic> json) {
    return _$AnalysisPrefsFromJson(json);
  }
}
