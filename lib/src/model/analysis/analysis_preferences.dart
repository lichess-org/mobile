import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_preferences.freezed.dart';
part 'analysis_preferences.g.dart';

@Riverpod(keepAlive: true)
class AnalysisPreferences extends _$AnalysisPreferences with PreferencesStorage<AnalysisPrefs> {
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

  Future<void> toggleEnableComputerAnalysis() {
    return save(state.copyWith(enableComputerAnalysis: !state.enableComputerAnalysis));
  }

  Future<void> toggleShowEvaluationGauge() {
    return save(state.copyWith(showEvaluationGauge: !state.showEvaluationGauge));
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
sealed class AnalysisPrefs with _$AnalysisPrefs implements Serializable {
  const AnalysisPrefs._();

  const factory AnalysisPrefs({
    @JsonKey(defaultValue: true) required bool enableComputerAnalysis,
    required bool showEvaluationGauge,
    required bool showBestMoveArrow,
    required bool showAnnotations,
    required bool showPgnComments,
    @JsonKey(defaultValue: false) required bool inlineNotation,
    @JsonKey(defaultValue: false) required bool smallBoard,
  }) = _AnalysisPrefs;

  static const defaults = AnalysisPrefs(
    enableComputerAnalysis: true,
    showEvaluationGauge: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    inlineNotation: false,
    smallBoard: false,
  );

  factory AnalysisPrefs.fromJson(Map<String, dynamic> json) {
    return _$AnalysisPrefsFromJson(json);
  }
}
