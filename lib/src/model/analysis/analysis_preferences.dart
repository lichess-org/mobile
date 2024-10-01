import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_preferences.freezed.dart';
part 'analysis_preferences.g.dart';

@Riverpod(keepAlive: true)
class AnalysisPreferences extends _$AnalysisPreferences {
  static const prefKey = 'preferences.analysis';

  @override
  AnalysisPrefState build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final stored = prefs.getString(prefKey);
    return stored != null
        ? AnalysisPrefState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : AnalysisPrefState.defaults;
  }

  Future<void> toggleEnableLocalEvaluation() {
    return _save(
      state.copyWith(
        enableLocalEvaluation: !state.enableLocalEvaluation,
      ),
    );
  }

  Future<void> toggleShowEvaluationGauge() {
    return _save(
      state.copyWith(
        showEvaluationGauge: !state.showEvaluationGauge,
      ),
    );
  }

  Future<void> toggleAnnotations() {
    return _save(
      state.copyWith(
        showAnnotations: !state.showAnnotations,
      ),
    );
  }

  Future<void> togglePgnComments() {
    return _save(
      state.copyWith(
        showPgnComments: !state.showPgnComments,
      ),
    );
  }

  Future<void> toggleShowBestMoveArrow() {
    return _save(
      state.copyWith(
        showBestMoveArrow: !state.showBestMoveArrow,
      ),
    );
  }

  Future<void> toggleShowVariationArrows() {
    return _save(
      state.copyWith(
        showVariationArrows: !state.showVariationArrows,
      ),
    );
  }

  Future<void> setNumEvalLines(int numEvalLines) {
    assert(numEvalLines >= 1 && numEvalLines <= 3);
    return _save(
      state.copyWith(
        numEvalLines: numEvalLines,
      ),
    );
  }

  Future<void> setEngineCores(int numEngineCores) {
    assert(numEngineCores >= 1 && numEngineCores <= maxEngineCores);
    return _save(
      state.copyWith(
        numEngineCores: numEngineCores,
      ),
    );
  }

  Future<void> _save(AnalysisPrefState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class AnalysisPrefState with _$AnalysisPrefState {
  const AnalysisPrefState._();

  const factory AnalysisPrefState({
    required bool enableLocalEvaluation,
    required bool showEvaluationGauge,
    required bool showBestMoveArrow,
    required bool showVariationArrows,
    required bool showAnnotations,
    required bool showPgnComments,
    @Assert('numEvalLines >= 1 && numEvalLines <= 3') required int numEvalLines,
    @Assert('numEngineCores >= 1 && numEngineCores <= maxEngineCores')
    required int numEngineCores,
  }) = _AnalysisPrefState;

  static final defaults = AnalysisPrefState(
    enableLocalEvaluation: true,
    showEvaluationGauge: true,
    showBestMoveArrow: true,
    showVariationArrows: true,
    showAnnotations: true,
    showPgnComments: true,
    numEvalLines: 2,
    numEngineCores: defaultEngineCores,
  );

  factory AnalysisPrefState.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnalysisPrefStateFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
