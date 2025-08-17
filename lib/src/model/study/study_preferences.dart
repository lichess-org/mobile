import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_preferences.freezed.dart';
part 'study_preferences.g.dart';

@Riverpod(keepAlive: true)
class StudyPreferences extends _$StudyPreferences with PreferencesStorage<StudyPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.study;

  @override
  @protected
  StudyPrefs get defaults => StudyPrefs.defaults;

  @override
  StudyPrefs fromJson(Map<String, dynamic> json) => StudyPrefs.fromJson(json);

  @override
  StudyPrefs build() {
    return fetch();
  }

  Future<void> toogleShowChatRoomButtonOverflowMenu() {
    return save(
      state.copyWith(showChatRoomButtonOverflowMenu: !state.showChatRoomButtonOverflowMenu),
    );
  }

  Future<void> toggleShowVariationArrows() {
    return save(state.copyWith(showVariationArrows: !state.showVariationArrows));
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

  Future<void> toggleSmallBoard() {
    return save(state.copyWith(smallBoard: !state.smallBoard));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class StudyPrefs with _$StudyPrefs implements Serializable, CommonAnalysisPrefs {
  const StudyPrefs._();

  const factory StudyPrefs({
    required bool showVariationArrows,

    @JsonKey(defaultValue: false) required bool showChatRoomButtonOverflowMenu,
    @JsonKey(defaultValue: true) required bool showEvaluationGauge,
    @JsonKey(defaultValue: true) required bool showEngineLines,
    @JsonKey(defaultValue: true) required bool showBestMoveArrow,
    @JsonKey(defaultValue: true) required bool showAnnotations,
    @JsonKey(defaultValue: true) required bool showPgnComments,
    @JsonKey(defaultValue: false) required bool inlineNotation,
    @JsonKey(defaultValue: false) required bool smallBoard,
  }) = _StudyPrefs;

  static const defaults = StudyPrefs(
    showChatRoomButtonOverflowMenu: false,
    showVariationArrows: false,
    showEvaluationGauge: true,
    showEngineLines: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    inlineNotation: false,
    smallBoard: false,
  );

  factory StudyPrefs.fromJson(Map<String, dynamic> json) {
    return _$StudyPrefsFromJson(json);
  }
}
