import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_preferences.freezed.dart';
part 'analysis_preferences.g.dart';

@riverpod
class AnalysisPreferences extends _$AnalysisPreferences
    with PreferencesStorage<AnalysisPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.analysis;

  // ignore: avoid_public_notifier_properties
  @override
  AnalysisPrefs get defaults => AnalysisPrefs.defaults;

  @override
  AnalysisPrefs fromJson(Map<String, dynamic> json) =>
      AnalysisPrefs.fromJson(json);

  @override
  AnalysisPrefs build() {
    return fetch();
  }

  Future<void> toggleEnableComputerAnalysis() {
    return save(
      state.copyWith(
        enableComputerAnalysis: !state.enableComputerAnalysis,
      ),
    );
  }

  Future<void> toggleEnableLocalEvaluation() {
    return save(
      state.copyWith(
        enableLocalEvaluation: !state.enableLocalEvaluation,
      ),
    );
  }

  Future<void> toggleShowEvaluationGauge() {
    return save(
      state.copyWith(
        showEvaluationGauge: !state.showEvaluationGauge,
      ),
    );
  }

  Future<void> toggleAnnotations() {
    return save(
      state.copyWith(
        showAnnotations: !state.showAnnotations,
      ),
    );
  }

  Future<void> togglePgnComments() {
    return save(
      state.copyWith(
        showPgnComments: !state.showPgnComments,
      ),
    );
  }

  Future<void> toggleShowBestMoveArrow() {
    return save(
      state.copyWith(
        showBestMoveArrow: !state.showBestMoveArrow,
      ),
    );
  }

  Future<void> setNumEvalLines(int numEvalLines) {
    assert(numEvalLines >= 0 && numEvalLines <= 3);
    return save(
      state.copyWith(
        numEvalLines: numEvalLines,
      ),
    );
  }

  Future<void> setEngineCores(int numEngineCores) {
    assert(numEngineCores >= 1 && numEngineCores <= maxEngineCores);
    return save(
      state.copyWith(
        numEngineCores: numEngineCores,
      ),
    );
  }
}

@Freezed(fromJson: true, toJson: true)
class AnalysisPrefs with _$AnalysisPrefs implements Serializable {
  const AnalysisPrefs._();

  const factory AnalysisPrefs({
    @JsonKey(defaultValue: true) required bool enableComputerAnalysis,
    required bool enableLocalEvaluation,
    required bool showEvaluationGauge,
    required bool showBestMoveArrow,
    required bool showAnnotations,
    required bool showPgnComments,
    @Assert('numEvalLines >= 0 && numEvalLines <= 3') required int numEvalLines,
    @Assert('numEngineCores >= 1 && numEngineCores <= maxEngineCores')
    required int numEngineCores,
  }) = _AnalysisPrefs;

  static const defaults = AnalysisPrefs(
    enableComputerAnalysis: true,
    enableLocalEvaluation: true,
    showEvaluationGauge: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    numEvalLines: 2,
    numEngineCores: 1,
  );

  factory AnalysisPrefs.fromJson(Map<String, dynamic> json) {
    return _$AnalysisPrefsFromJson(json);
  }
}
