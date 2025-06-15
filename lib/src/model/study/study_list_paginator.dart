import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_list_paginator.g.dart';

typedef StudyList = ({IList<StudyPageItem> studies, int? nextPage});

/// Gets a list of studies from the paginated API.
@riverpod
class StudyListPaginator extends _$StudyListPaginator {
  @override
  Future<StudyList> build({
    required StudyCategory category,
    required StudyListOrder order,
    String? search,
  }) {
    return _nextPage();
  }

  Future<void> next() async {
    final studyList = state.requireValue;
    if (studyList.nextPage == null) return;

    final newStudyPage = await _nextPage();

    state = AsyncData((
      nextPage: newStudyPage.nextPage,
      studies: studyList.studies.addAll(newStudyPage.studies),
    ));
  }

  Future<StudyList> _nextPage() {
    final nextPage = state.value?.nextPage ?? 1;

    final repo = ref.read(studyRepositoryProvider);
    return search == null
        ? repo.getStudies(category: category, order: order, page: nextPage)
        : repo.searchStudies(query: search!, page: nextPage);
  }
}
