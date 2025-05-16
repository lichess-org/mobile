import 'package:freezed_annotation/freezed_annotation.dart';
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

  Future<void> toggleShowVariationArrows() {
    return save(state.copyWith(showVariationArrows: !state.showVariationArrows));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class StudyPrefs with _$StudyPrefs implements Serializable {
  const StudyPrefs._();

  const factory StudyPrefs({required bool showVariationArrows}) = _StudyPrefs;

  static const defaults = StudyPrefs(showVariationArrows: false);

  factory StudyPrefs.fromJson(Map<String, dynamic> json) {
    return _$StudyPrefsFromJson(json);
  }
}
