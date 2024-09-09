import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_filter.freezed.dart';
part 'study_filter.g.dart';

enum StudyCategory {
  all,
  mine,
  member,
  public,
  private,
  likes,
}

enum StudyListOrder {
  hot,
  popular,
  newest,
  oldest,
  updated,
}

@riverpod
class StudyFilter extends _$StudyFilter {
  @override
  StudyFilterState build() => const StudyFilterState();

  void setCategory(StudyCategory category) =>
      state = state.copyWith(category: category);

  void setOrder(StudyListOrder order) => state = state.copyWith(order: order);
}

@freezed
class StudyFilterState with _$StudyFilterState {
  const StudyFilterState._();

  const factory StudyFilterState({
    @Default(StudyCategory.all) StudyCategory category,
    @Default(StudyListOrder.hot) StudyListOrder order,
  }) = _StudyFilterState;
}
