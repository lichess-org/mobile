import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coach/coach.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/network/http.dart';

typedef CoachListPage = ({
  IList<CoachPreview> coaches,
  int? nextPage,
  IList<String> languages,
  IList<CoachFilterOption> countries,
});

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return CoachRepository(ref.watch(lichessClientProvider));
}, name: 'CoachRepositoryProvider');

class CoachRepository(final LichessClient _client) {
  Future<CoachListPage> getCoaches(CoachFilters filters, {int page = 1}) {
    return _client.readJson(
      Uri(
        path: '/api/mobile/coach',
        queryParameters: {
          'page': page.toString(),
          'lang': filters.language,
          'country': filters.country,
          'order': filters.order.key,
        },
      ),
      mapper: (json) {
        return (
          coaches: pick(
            json,
            'coaches',
          ).asListOrThrow((p) => CoachPreview.fromPick(p.required())).toIList(),
          nextPage: pick(json, 'nextPage').asIntOrNull(),
          languages: pick(json, 'languages').asListOrEmpty((p) => p.asStringOrThrow()).toIList(),
          countries: pick(json, 'countries')
              .asListOrEmpty(
                (p) => CoachFilterOption(
                  code: p('code').asStringOrThrow(),
                  name: p('name').asStringOrThrow(),
                ),
              )
              .toIList(),
        );
      },
    );
  }

  Future<CoachProfile> getCoach(String username) {
    return _client.readJson(
      Uri(path: '/api/mobile/coach/$username'),
      mapper: (json) => CoachProfile.fromPick(pick(json).required()),
    );
  }
}
