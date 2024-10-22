import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_preferences.freezed.dart';
part 'study_preferences.g.dart';

@riverpod
class StudyPreferences extends _$StudyPreferences
    with PreferencesStorage<StudyPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.study;

  // ignore: avoid_public_notifier_properties
  @override
  StudyPrefs get defaults => StudyPrefs.defaults;

  @override
  StudyPrefs fromJson(Map<String, dynamic> json) => StudyPrefs.fromJson(json);

  @override
  StudyPrefs build() {
    return fetch();
  }

  Future<void> toggleShowVariationArrows() {
    return save(
      state.copyWith(
        showVariationArrows: !state.showVariationArrows,
      ),
    );
  }
}

@Freezed(fromJson: true, toJson: true)
class StudyPrefs with _$StudyPrefs implements Serializable {
  const StudyPrefs._();

  const factory StudyPrefs({
    required bool showVariationArrows,
  }) = _StudyPrefs;

  static const defaults = StudyPrefs(
    showVariationArrows: false,
  );

  factory StudyPrefs.fromJson(Map<String, dynamic> json) {
    return _$StudyPrefsFromJson(json);
  }
}
