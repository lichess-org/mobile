import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_preferences.g.dart';

@riverpod
class AnalysisPreferences extends _$AnalysisPreferences
    with PreferencesStorage<pref.Analysis> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.Analysis> get categoryKey => pref.Category.analysis;

  @override
  pref.Analysis build() {
    return fetch();
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
    assert(numEvalLines >= 1 && numEvalLines <= 3);
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
