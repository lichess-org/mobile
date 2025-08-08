import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/cache.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Aggregator');

typedef GroupedFuture = Future<Map<String, dynamic>>;

final Uri _homeUri = Uri(path: '/api/mobile/home');
final Uri _watchUri = Uri(path: '/api/mobile/watch');
final Map<Uri, ISet<({String key, RegExp pathRegexp})>> _groupedUris = {
  _homeUri: ISet({
    (key: 'account', pathRegexp: RegExp(r'^\/api\/account$')),
    (key: 'recentGames', pathRegexp: RegExp(r'^\/api\/games\/user\/[\w-]+$')),
    (key: 'ongoingGames', pathRegexp: RegExp(r'^\/api\/account\/playing$')),
    (key: 'tournaments', pathRegexp: RegExp(r'^\/tournament\/featured$')),
    (key: 'inbox', pathRegexp: RegExp(r'^\/inbox\/unread-count$')),
  }),
  _watchUri: ISet({
    (key: 'broadcast', pathRegexp: RegExp(r'^\/api\/broadcast\/top$')),
    (key: 'tv', pathRegexp: RegExp(r'^\/api\/tv\/channels$')),
    (key: 'streamers', pathRegexp: RegExp(r'^\/api\/streamer\/live$')),
  }),
};

/// A provider that aggregates requests to the Lichess API.
final aggregatorProvider = Provider<Aggregator>((ref) {
  return Aggregator(ref.read(lichessClientProvider));
}, name: 'AggregatorProvider');

/// Aggregator is used to group multiple requests to the same endpoint.
class Aggregator {
  Aggregator(this.client);

  final LichessClient client;

  (Future<void>, ISet<Uri>)? _pending;

  final MemoryCache<ISet<Uri>, ({Uri targetGroupUri, GroupedFuture future})> _groupRequests =
      MemoryCache(defaultExpiry: const Duration(seconds: 5));

  Future<T> call<T>(Uri uri, {required T Function(Map<String, dynamic>) mapper}) async {
    if (_pending == null) {
      _pending = (Future<void>.delayed(const Duration(milliseconds: 50)), ISet({uri}));
    } else {
      _pending = (_pending!.$1, _pending!.$2.add(uri));
    }

    await _pending!.$1;

    if (_pending != null) {
      final (_, uris) = _pending!;
      _pending = null;

      if (uris.length == 1) {
        return client.readJson(uri, mapper: mapper);
      }

      for (final group in _groupedUris.entries) {
        // test that list of uris matches the group
        // TODO: for now this doesn't work if an uri can be in multiple groups
        if (uris.any((e) => group.value.any((g) => g.pathRegexp.hasMatch(e.path)))) {
          _groupRequests.putIfAbsent(
            uris,
            () => (targetGroupUri: group.key, future: client.readJson(group.key, mapper: (x) => x)),
          );
        }
      }
    }

    final uris = _groupRequests.keys.firstWhereOrNull((key) => key.any((e) => e.path == uri.path));

    if (uris != null) {
      final entry = _groupRequests[uris]!;
      final aggregated = await entry.future;
      final group = _groupedUris[entry.targetGroupUri]!;
      final jsonKey = group.firstWhere((e) => e.pathRegexp.hasMatch(uri.path)).key;
      final Map<String, dynamic> result = aggregated[jsonKey] as Map<String, dynamic>;

      return mapper(result);
    }

    _logger.warning('No aggregation found for URI: $uri');

    return client.readJson(uri, mapper: mapper);
  }
}
