import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_filter.freezed.dart';
part 'study_filter.g.dart';

enum StudyCategory {
  all,
  mine,
  member,
  public,
  private,
  likes;

  String l10n(AppLocalizations l10n) => switch (this) {
    StudyCategory.all => l10n.studyAllStudies,
    StudyCategory.mine => l10n.studyMyStudies,
    StudyCategory.member => l10n.studyStudiesIContributeTo,
    StudyCategory.public => l10n.studyMyPublicStudies,
    StudyCategory.private => l10n.studyMyPrivateStudies,
    StudyCategory.likes => l10n.studyMyFavoriteStudies,
  };
}

enum StudyListOrder {
  hot,
  popular,
  newest,
  oldest,
  updated;

  String l10n(AppLocalizations l10n) => switch (this) {
    StudyListOrder.hot => l10n.studyHot,
    StudyListOrder.newest => l10n.studyDateAddedNewest,
    StudyListOrder.oldest => l10n.studyDateAddedOldest,
    StudyListOrder.updated => l10n.studyRecentlyUpdated,
    StudyListOrder.popular => l10n.studyMostPopular,
  };
}

@riverpod
class StudyFilter extends _$StudyFilter {
  @override
  StudyFilterState build() => const StudyFilterState();

  void setCategory(StudyCategory category) => state = state.copyWith(category: category);

  void setOrder(StudyListOrder order) => state = state.copyWith(order: order);
}

@freezed
sealed class StudyFilterState with _$StudyFilterState {
  const StudyFilterState._();

  const factory StudyFilterState({
    @Default(StudyCategory.all) StudyCategory category,
    @Default(StudyListOrder.hot) StudyListOrder order,
  }) = _StudyFilterState;
}
