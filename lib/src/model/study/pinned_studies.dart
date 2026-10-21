import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'pinned_studies.freezed.dart';
part 'pinned_studies.g.dart';

/// Maximum number of studies that can be pinned to the Learn tab.
const kMaxPinnedStudies = 8;

/// The studies pinned to the Learn tab, stored locally for each account.
final pinnedStudiesProvider = NotifierProvider<PinnedStudiesNotifier, PinnedStudies>(
  PinnedStudiesNotifier.new,
  name: 'PinnedStudiesProvider',
);

class PinnedStudiesNotifier()
    extends Notifier<PinnedStudies>
    with SessionPreferencesStorage<PinnedStudies> {
  @override
  @protected
  PrefCategory get prefCategory => PrefCategory.pinnedStudies;

  @override
  @protected
  PinnedStudies defaults({LightUser? user}) => PinnedStudies.empty;

  @override
  PinnedStudies fromJson(Map<String, dynamic> json) => PinnedStudies.fromJson(json);

  @override
  PinnedStudies build() {
    return fetch();
  }

  /// Pins [study] at the end of the list, opening it later at its current chapter.
  ///
  /// Does nothing if the study is already pinned or if [kMaxPinnedStudies] is reached.
  Future<void> pin(Study study) {
    if (state.isPinned(study.id) || state.isFull) {
      return Future.value();
    }
    return save(state.copyWith(studies: state.studies.add(PinnedStudy.fromStudy(study))));
  }

  Future<void> unpin(StudyId id) {
    if (!state.isPinned(id)) {
      return Future.value();
    }
    return save(state.copyWith(studies: state.studies.removeWhere((s) => s.id == id)));
  }

  /// Updates the stored name, chapter count and last viewed chapter of [study], if it is pinned.
  Future<void> updateFromStudy(Study study) {
    final index = state.studies.indexWhere((s) => s.id == study.id);
    if (index == -1) {
      return Future.value();
    }
    final updated = PinnedStudy.fromStudy(study);
    if (state.studies[index] == updated) {
      return Future.value();
    }
    return save(state.copyWith(studies: state.studies.replace(index, updated)));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const PinnedStudies._() with _$PinnedStudies implements Serializable {
  const factory({required IList<PinnedStudy> studies}) = _PinnedStudies;

  static const empty = PinnedStudies(studies: IListConst([]));

  bool isPinned(StudyId id) => studies.any((s) => s.id == id);

  bool get isFull => studies.length >= kMaxPinnedStudies;

  factory fromJson(Map<String, dynamic> json) {
    try {
      return _$PinnedStudiesFromJson(json);
    } catch (e) {
      return empty;
    }
  }
}

/// A study pinned to the Learn tab.
///
/// The name and chapter count are stored so that the Learn tab can show the study without
/// fetching it.
@Freezed(fromJson: true, toJson: true)
sealed class const PinnedStudy._() with _$PinnedStudy {
  const factory({
    required StudyId id,
    required String name,
    required int chapterCount,

    /// The chapter that was open the last time the study was viewed.
    StudyChapterId? lastChapterId,
  }) = _PinnedStudy;

  factory fromStudy(Study study) => PinnedStudy(
    id: study.id,
    name: study.name,
    chapterCount: study.chapters.length,
    lastChapterId: study.chapter.id,
  );

  factory fromJson(Map<String, dynamic> json) => _$PinnedStudyFromJson(json);
}
