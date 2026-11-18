import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
  Future<CoachListPage> build() async {
    final page = await ref.read(coachRepositoryProvider).getCoaches(params);
    final seen = <String>{};
    return (
      coaches: page.coaches.where((coach) => seen.add(coach.user.id.value)).toIList(),
      nextPage: page.nextPage,
      languages: page.languages,
      countries: page.countries,
    );
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

      final seen = current.coaches.map((coach) => coach.user.id.value).toSet();
      state = AsyncData((
        coaches: current.coaches.addAll(
          newPage.coaches.where((coach) => seen.add(coach.user.id.value)),
        ),
        nextPage: newPage.nextPage,
        languages: newPage.languages,
        countries: newPage.countries,
      ));
    } finally {
      _loadingPage = null;
    }
  }
}
