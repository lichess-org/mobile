import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/cache.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Aggregator');

const kAggregationInterval = Duration(milliseconds: 5);

final Uri _homeUri = Uri(path: '/api/mobile/home');
final Uri _watchUri = Uri(path: '/api/mobile/watch');

/// An endpoint key in an aggregated payload, and the client-side uris it can answer.
///
/// [queryParams] lists the query parameters that the aggregated response still
/// represents. A client-side uri carrying any other parameter cannot be served
/// from the aggregated payload, because that payload would silently ignore the
/// parameter, so such a uri must not join the group.
typedef _AggregatedEndpoint = ({String key, RegExp pathRegexp, Set<String> queryParams});

/// Whether [endpoint] can answer a request for [uri].
///
/// The path must match, and the uri must not carry a query parameter that
/// [endpoint]'s aggregated payload does not represent.
bool _represents(_AggregatedEndpoint endpoint, Uri uri) =>
    endpoint.pathRegexp.hasMatch(uri.path) &&
    uri.queryParameters.keys.every(endpoint.queryParams.contains);

/// Map of target URIs to their grouped client-side URIs and JSON keys.
final Map<Uri, ISet<_AggregatedEndpoint>> _targetUris = {
  _homeUri: ISet({
    (key: 'account', pathRegexp: RegExp(r'^\/api\/account$'), queryParams: const {'playban'}),
    (
      key: 'recentGames',
      pathRegexp: RegExp(r'^\/api\/games\/user\/[\w-]+$'),
      // the aggregated payload is the last 10 games of the logged in user, with
      // moves, lastFen, accuracy and opening: the game history filters
      // (perfType, color, vs, wonBy, lostBy, analysed, until, ...) are all
      // outside this set and must be fetched on their own
      queryParams: const {'max', 'moves', 'lastFen', 'accuracy', 'opening'},
    ),
    (
      key: 'ongoingGames',
      pathRegexp: RegExp(r'^\/api\/account\/playing$'),
      queryParams: const {'nb'},
    ),
    (key: 'challenges', pathRegexp: RegExp(r'^\/api\/challenge$'), queryParams: const {}),
    (key: 'tournaments', pathRegexp: RegExp(r'^\/tournament\/featured$'), queryParams: const {}),
    (key: 'inbox', pathRegexp: RegExp(r'^\/inbox\/unread-count$'), queryParams: const {}),
    (key: 'friends', pathRegexp: RegExp(r'^\/api\/mobile\/following$'), queryParams: const {'nb'}),
  }),
  _watchUri: ISet({
    (key: 'broadcast', pathRegexp: RegExp(r'^\/api\/broadcast\/top$'), queryParams: const {'page'}),
    (key: 'tv', pathRegexp: RegExp(r'^\/api\/tv\/channels$'), queryParams: const {}),
    (key: 'streamers', pathRegexp: RegExp(r'^\/api\/streamer\/live$'), queryParams: const {}),
  }),
};

typedef CachedAggregatorRequest = ({Uri targetGroupUri, Future<Map<String, dynamic>> future});

/// A provider for the [Aggregator] service.
final aggregatorProvider = Provider<Aggregator>((ref) {
  return Aggregator(ref.watch(lichessClientProvider));
}, name: 'AggregatorProvider');

/// Aggregator is used to group multiple requests to the same endpoint.
///
/// This service should be used for endpoints that are frequently called in a short time span in a specific
/// context, such as the home screen or watch screen.
///
/// It will wait for [aggregationInterval] after the first request call and during that time it will collect more that
/// can be aggregated into a single request.
/// The result of that aggregated request is in turn cached for 5 seconds.
///
/// There is a match with a target server grouped endpoint, only
/// if all uris grouped client side match the target server endpoint configuration.
///
/// If there is no match, it will make atomic requests for each uri after the [aggregationInterval] delay.
class Aggregator(
  final LichessClient client, {
  final Duration aggregationInterval = kAggregationInterval,
}) {
  (Future<void>, ISet<Uri>)? _pending;

  final MemoryCache<ISet<Uri>, CachedAggregatorRequest> _groupRequests = MemoryCache(
    defaultExpiry: const Duration(seconds: 5),
  );

  Future<T> readJson<T>(
    Uri url, {
    Map<String, String>? headers,

    /// The mapper function to apply to the atomic JSON response.
    required T Function(Map<String, dynamic>) atomicMapper,

    /// The mapper function to apply to the corresponding value found in aggregated JSON response.
    ///
    /// If not provided, the [atomicMapper] will be used for aggregation.
    T Function(Object)? aggregatedMapper,
  }) => _call<T>(
    url,
    atomicClientCall: () => client.readJson(url, headers: headers, mapper: atomicMapper),
    mapper: aggregatedMapper ?? (json) => atomicMapper(json as Map<String, dynamic>),
  );

  Future<IList<T>> readJsonList<T>(
    Uri url, {
    Map<String, String>? headers,
    required T? Function(Map<String, dynamic>) mapper,
  }) => _call<IList<T>>(
    url,
    atomicClientCall: () => client.readJsonList(url, headers: headers, mapper: mapper),
    mapper: (json) => decodeObjectList<T>(json, mapper: mapper),
  );

  Future<IList<T>> readNdJsonList<T>(
    Uri url, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) mapper,
  }) => _call<IList<T>>(
    url,
    atomicClientCall: () => client.readNdJsonList(url, headers: headers, mapper: mapper),
    mapper: (json) => decodeObjectList<T>(json, mapper: mapper),
  );

  Future<U> _call<U>(
    Uri uri, {

    /// The atomic client call to make if no aggregation is found.
    required Future<U> Function() atomicClientCall,

    /// The mapper function to apply to the corresponding value found in aggregated JSON response.
    required U Function(Object) mapper,
  }) async {
    // Aggregation is disabled for widget tests to avoid dealing with timer and extra complexity.
    // The Aggregator is tested on its own.
    if (aggregationInterval == Duration.zero) {
      return await atomicClientCall();
    }

    if (_pending == null) {
      _pending = (Future<void>.delayed(aggregationInterval), ISet({uri}));
    } else {
      _pending = (_pending!.$1, _pending!.$2.add(uri));
    }

    await _pending!.$1;

    // aggregating time has elapsed, process the pending requests once
    if (_pending != null) {
      final (_, uris) = _pending!;
      _pending = null;

      if (uris.length == 1) {
        return await atomicClientCall();
      }

      for (final group in _targetUris.entries) {
        // No point in making an aggregated request if we don't have enough accumulated URIs
        final hasEnoughUris = uris.length >= group.value.length / 2;
        if (hasEnoughUris &&
            // test that list of uris matches all the group uris, and that the aggregated
            // payload still represents them: a uri carrying a query parameter the group
            // does not reproduce (e.g. `analysed` on the game history) must not be
            // grouped, otherwise it would later be served an unfiltered response
            uris.every((e) => group.value.any((g) => _represents(g, e)))) {
          _groupRequests.putIfAbsent(
            uris,
            () => (targetGroupUri: group.key, future: client.readJson(group.key, mapper: (x) => x)),
          );
          break;
        }
      }
    }

    // only a uri that took part in the group may be served from the aggregated
    // response: a uri with different query parameters (e.g. `analysed` on the game
    // history) must hit the network, as the aggregated payload does not apply them
    final uris = _groupRequests.keys.firstWhereOrNull((key) => key.contains(uri));
    if (uris != null) {
      final entry = _groupRequests[uris]!;
      final aggregated = await entry.future;
      final group = _targetUris[entry.targetGroupUri]!;
      final jsonKey = group.firstWhere((e) => _represents(e, uri)).key;
      final result = aggregated[jsonKey] as Object;

      return mapper(result);
    }

    _logger.warning('No aggregation found for URI: $uri');

    return await atomicClientCall();
  }
}
