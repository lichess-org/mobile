import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';

final coachListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<CoachListController, CoachListPage, CoachFilters>(
      CoachListController.new,
      name: 'CoachListControllerProvider',
    );

class CoachListController(final CoachFilters params) extends AsyncNotifier<CoachListPage> {
  @override
  Future<CoachListPage> build() {
    return ref.read(coachRepositoryProvider).getCoaches(params);
  }

  Future<void> next() async {
    final list = state.requireValue;
    final nextPage = list.nextPage;
    if (nextPage == null) return;

    final newPage = await ref.read(coachRepositoryProvider).getCoaches(params, page: nextPage);

    if (!ref.mounted) return;

    state = AsyncData((
      coaches: list.coaches.addAll(newPage.coaches),
      nextPage: newPage.nextPage,
      languages: newPage.languages,
      countries: newPage.countries,
    ));
  }
}
