import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';

final coachListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<CoachListController, CoachListPage, CoachFilters>(
      CoachListController.new,
      name: 'CoachListControllerProvider',
    );

class CoachListController(final CoachFilters params) extends AsyncNotifier<CoachListPage> {
  int? _loadingPage;

  @override
  Future<CoachListPage> build() {
    return ref.read(coachRepositoryProvider).getCoaches(params);
  }

  Future<void> next() async {
    final nextPage = state.requireValue.nextPage;
    if (nextPage == null || _loadingPage != null) return;
    _loadingPage = nextPage;

    try {
      final newPage = await ref.read(coachRepositoryProvider).getCoaches(params, page: nextPage);

      if (!ref.mounted) return;
      final current = state.value;
      if (current == null || current.nextPage != nextPage) return;

      state = AsyncData((
        coaches: current.coaches.addAll(newPage.coaches),
        nextPage: newPage.nextPage,
        languages: newPage.languages,
        countries: newPage.countries,
      ));
    } finally {
      _loadingPage = null;
    }
  }
}
