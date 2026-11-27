import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

final fideRepositoryProvider = Provider<FideRepository>((ref) {
  return FideRepository(ref.watch(lichessClientProvider));
}, name: 'FideRepositoryProvider');

class FideRepository(final LichessClient client) {
  /// Fetches a page of the FIDE players, sorted by [order], or matching [query].
  ///
  /// A [query] sorts players by relevance, and a FIDE ID returns only that player.
  Future<FidePlayerPage> getPlayers({
    int page = 1,
    FidePlayerOrder order = .standard,
    String? query,
  }) {
    return client.readJson(
      Uri(
        path: '/fide',
        queryParameters: {
          'page': page.toString(),
          if (query != null && query.isNotEmpty) 'q': query else 'order': order.name,
        },
      ),
      headers: {'Accept': 'application/json'},
      mapper: (json) => (
        players: pick(json, 'currentPageResults').asListOrThrow(_playerFromPick).toIList(),
        nextPage: pick(json, 'nextPage').asIntOrNull(),
      ),
    );
  }

  /// Fetches a FIDE player.
  Future<FidePlayerDetails> getPlayer(FideId id) {
    return client.readJson(
      // The JSON response ignores the name slug the HTML page redirects to.
      Uri(path: '/fide/$id/-'),
      headers: {'Accept': 'application/json'},
      mapper: (json) {
        final root = pick(json).required();
        return (
          player: _playerFromPick(root),
          user: root('user').asLightUserOrNull(),
          ratingHistory: _ratingHistoryFromPick(root('ratings')),
        );
      },
    );
  }
}

FidePlayer _playerFromPick(RequiredPick pick) {
  return FidePlayer(
    id: pick('id').asFideIdOrThrow(),
    name: pick('name').asStringOrThrow(),
    federation: pick('federation').asFederationIdOrNull(),
    birthYear: pick('year').asIntOrNull(),
    title: pick('title').asStringOrNull(),
    ratings: {for (final tc in BroadcastFideTC.values) tc: ?pick(tc.name).asIntOrNull()}.lock,
    photo: pick('photo').letOrNull(
      (photo) => (
        smallUrl: photo('small').asStringOrThrow(),
        mediumUrl: photo('medium').asStringOrThrow(),
        credit: photo('credit').asStringOrNull(),
      ),
    ),
    following: pick('following').asBoolOrFalse(),
  );
}

/// Reads lichess' rating points, integers like 2021031800 for an Elo of 1800 in March 2021.
IMap<BroadcastFideTC, IList<UserRatingHistoryPoint>> _ratingHistoryFromPick(Pick pick) {
  return {
    for (final tc in BroadcastFideTC.values)
      if (pick(tc.name).asListOrNull((p) => p.asIntOrThrow()) case final points?
          when points.isNotEmpty)
        tc: points.map((point) {
          final yearMonth = point ~/ 10000;
          return UserRatingHistoryPoint(
            date: DateTime.utc(yearMonth ~/ 100, yearMonth % 100),
            elo: point % 10000,
          );
        }).toIList(),
  }.lock;
}
