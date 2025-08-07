import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/network/http.dart';

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

/// Aggregator is used to group multiple requests to the same endpoint.
class Aggregator {
  Aggregator(this.client);

  final LichessClient client;

  (Future<void>, ISet<Uri>)? _pending;

  final Map<ISet<Uri>, ({Uri groupUri, GroupedFuture future, int nbExtracted})> _groupRequests = {};

  Future<T> call<T>(Uri uri, {required T Function(Map<String, dynamic>) mapper}) async {
    if (_pending == null) {
      _pending = (Future<void>.delayed(const Duration(milliseconds: 50)), ISet(const {}));
    } else {
      _pending = (_pending!.$1, _pending!.$2.add(uri));
    }

    await _pending!.$1;

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
          () => (
            groupUri: group.key,
            future: client.readJson(group.key, mapper: (x) => x),
            nbExtracted: 0,
          ),
        );
      }
    }

    final entry = _groupRequests[uris];
    if (entry != null) {
      final aggregated = await entry.future;
      final group = _groupedUris[entry.groupUri]!;
      final jsonKey = group.firstWhere((e) => e.pathRegexp.hasMatch(uri.path)).key;
      final Map<String, dynamic> result = aggregated[jsonKey] as Map<String, dynamic>;

      _groupRequests.update(
        uris,
        (value) =>
            (groupUri: value.groupUri, future: value.future, nbExtracted: value.nbExtracted + 1),
      );

      if (_groupRequests[uris]!.nbExtracted == uris.length) {
        _groupRequests.remove(uris);
      }

      return mapper(result);
    }

    assert(false, 'No group found for $uris, this cannot happen.');
    return client.readJson(uri, mapper: mapper);
  }
}
