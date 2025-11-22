import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';

typedef StudyList = ({IList<StudyPageItem> studies, int? nextPage});
typedef StudyListNotifierParams = ({StudyCategory category, StudyListOrder order, String? search});

/// A provider that gets a list of studies from the paginated API.
final studyListPaginatorProvider = AsyncNotifierProvider.autoDispose
    .family<StudyListPaginatorNotifier, StudyList, StudyListNotifierParams>(
      StudyListPaginatorNotifier.new,
      name: 'StudyListPaginatorProvider',
    );

class StudyListPaginatorNotifier extends AsyncNotifier<StudyList> {
  StudyListPaginatorNotifier(this.params);

  final StudyListNotifierParams params;

  @override
  Future<StudyList> build() {
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
    return params.search == null
        ? repo.getStudies(category: params.category, order: params.order, page: nextPage)
        : repo.searchStudies(query: params.search!, page: nextPage);
  }
}
