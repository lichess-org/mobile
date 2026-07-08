import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../utils/fake_connectivity.dart';
import '../auth/fake_auth_storage.dart';

/// Returns a raw API puzzle JSON document (game + puzzle) with puzzle [id].
String _puzzleJsonWithId(String id) {
  final map = jsonDecode(_basePuzzleJson) as Map<String, dynamic>;
  (map['puzzle'] as Map<String, dynamic>)['id'] = id;
  return jsonEncode(map);
}

/// Returns a `/api/streak` response: a puzzle document whose embedded puzzle is
/// [ids].first, plus the space-separated [ids] streak string.
String _streakJson(List<String> ids) {
  final map = jsonDecode(_basePuzzleJson) as Map<String, dynamic>;
  (map['puzzle'] as Map<String, dynamic>)['id'] = ids.first;
  map['streak'] = ids.join(' ');
  return jsonEncode(map);
}

/// An http client that fails every request, simulating being offline.
final _offlineClient = MockClient((request) async => http.Response('', 500));

/// A `/api/puzzle/many?ids=a,b,c` response: the batch envelope (`{puzzles: […]}`)
/// with one puzzle document per requested id, mirroring the lila endpoint.
String _manyJson(Iterable<String> ids) {
  return jsonEncode({'puzzles': ids.map((id) => jsonDecode(_puzzleJsonWithId(id))).toList()});
}

/// An http client that serves `/api/streak`, `/api/puzzle/many` and
/// `/api/puzzle/{id}` for any id.
MockClient _onlineClient(List<String> streakIds) {
  return MockClient((request) async {
    final path = request.url.path;
    if (path == '/api/streak') {
      return http.Response(_streakJson(streakIds), 200);
    }
    if (path == '/api/puzzle/many') {
      return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
    }
    if (path.startsWith('/api/puzzle/')) {
      return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
    }
    return http.Response('', 404);
  });
}

/// Records which puzzle ids were requested via `/api/puzzle/many` (one entry
/// per request) and via individual `/api/puzzle/{id}` requests.
class _RequestLog {
  final manyIds = <List<String>>[];
  final singleIds = <String>[];
}

/// An [_onlineClient] that additionally records puzzle requests into [log].
MockClient _countingClient(List<String> streakIds, _RequestLog log) {
  return MockClient((request) async {
    final path = request.url.path;
    if (path == '/api/streak') {
      return http.Response(_streakJson(streakIds), 200);
    }
    if (path == '/api/puzzle/many') {
      final requested = request.url.queryParameters['ids']!.split(',');
      log.manyIds.add(requested);
      return http.Response(_manyJson(requested), 200);
    }
    if (path.startsWith('/api/puzzle/')) {
      final id = path.split('/').last;
      log.singleIds.add(id);
      return http.Response(_puzzleJsonWithId(id), 200);
    }
    return http.Response('', 404);
  });
}

/// A client that throws while `isOnline()` is false — simulating being offline
/// — and serves `/api/streak` (when [streakIds] is given) and puzzles when
/// online.
MockClient _reconnectingClient(bool Function() isOnline, {List<String>? streakIds}) {
  return MockClient((request) async {
    if (!isOnline()) {
      throw http.ClientException('offline');
    }
    final path = request.url.path;
    if (streakIds != null && path == '/api/streak') {
      return http.Response(_streakJson(streakIds), 200);
    }
    if (path == '/api/puzzle/many') {
      return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
    }
    if (path.startsWith('/api/puzzle/')) {
      return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
    }
    return http.Response('', 200);
  });
}

Future<ProviderContainer> _makeContainer(http.Client client, {AuthUser? authUser}) => makeContainer(
  authUser: authUser,
  overrides: {
    httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
      (ref) => FakeHttpClientFactory(() => client),
    ),
  },
);

/// Keeps the `autoDispose` controller alive for the rest of the test so that
/// state mutations and subsequent reads hit the same notifier instance.
///
/// Must be called *after* any storage/streak pre-population, since listening
/// triggers `build()` eagerly. The `onError` handler swallows eager-build errors
/// (the error-path tests assert via `expectLater` on `.future` instead).
void _keepAlive(ProviderContainer container) {
  container.listen(puzzleStreakControllerProvider, (_, _) {}, onError: (_, _) {});
}

/// Polls the controller until its [AsyncValue] carries an error and returns it.
///
/// We can't simply `await` the controller's `.future` here: Riverpod 3
/// auto-retries a failed provider with exponential backoff, so the state stays
/// `AsyncLoading` (carrying the error) and the future never completes. We assert
/// that the error *surfaced* instead.
Future<Object?> _awaitBuildError(ProviderContainer container) async {
  for (var i = 0; i < 200; i++) {
    final value = container.read(puzzleStreakControllerProvider);
    if (value.error != null) return value.error;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  return null;
}

/// Polls [storage] until [id] is present (best-effort prefetch is async and
/// fire-and-forget), giving up after a short timeout.
Future<Puzzle?> _waitForCached(PuzzleStorage storage, PuzzleId id) async {
  for (var i = 0; i < 100; i++) {
    final cached = await storage.fetch(puzzleId: id);
    if (cached != null) return cached;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  return null;
}

/// Waits until [connectivityChangesProvider] reports the wanted status.
Future<void> _waitForConnectivity(ProviderContainer container, {required bool isOnline}) async {
  for (var i = 0; i < 200; i++) {
    if (container.read(connectivityChangesProvider).value?.isOnline == isOnline) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('connectivity did not report isOnline=$isOnline');
}

/// A [PuzzleStorage] whose cache writes always fail, to prove a network fetch is
/// still returned (not discarded) when the local cache write throws. Reads use
/// the real database via the inherited [PuzzleStorage.fetch].
class _SaveThrowingStorage extends PuzzleStorage {
  _SaveThrowingStorage(super.db);

  @override
  Future<void> save({required Puzzle puzzle}) =>
      Future.error(Exception('simulated disk-write failure'));
}

PuzzleStreak _activeStreak(List<String> ids, {int index = 0}) => PuzzleStreak(
  streak: IList(ids.map((e) => PuzzleId(e))),
  index: index,
  hasSkipped: false,
  finished: false,
  timestamp: DateTime.now(),
);

/// Builds a real [Puzzle] for pre-populating the SQLite cache.
Puzzle _puzzle(String id) => Puzzle(
  puzzle: PuzzleData(
    id: PuzzleId(id),
    rating: 1012,
    plays: 5557,
    initialPly: 66,
    solution: IList(const ['e5e1', 'g1h2', 'f6f4', 'g2g3', 'f4f2']),
    themes: ISet(const ['endgame', 'long', 'mateIn3']),
  ),
  game: const PuzzleGame(
    id: GameId('Xndtxsoa'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(side: Side.white, name: 'VincV'),
    black: PuzzleGamePlayer(side: Side.black, name: 'Rex9646'),
    pgn: 'e4 c5 Nf3 e6 d4 cxd4',
  ),
);

void main() {
  // Required by the connectivity provider, which registers an [AppLifecycleListener].
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PuzzleStreakController local-first fetching', () {
    test('a fresh streak caches the embedded index 0 and index 1 puzzles', () async {
      final ids = ['AAAAA', 'BBBBB', 'CCCCC'];
      final container = await _makeContainer(_onlineClient(ids));

      _keepAlive(container);
      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.puzzle.puzzle.id, const PuzzleId('AAAAA'));
      expect(state.nextPuzzle?.puzzle.id, const PuzzleId('BBBBB'));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      // index 0 arrives embedded in /api/streak and must be saved explicitly.
      expect(
        (await puzzleStorage.fetch(puzzleId: const PuzzleId('AAAAA')))?.puzzle.id,
        const PuzzleId('AAAAA'),
      );
      // index 1 is fetched via fetchPuzzle, which saves on the network path.
      expect(
        (await puzzleStorage.fetch(puzzleId: const PuzzleId('BBBBB')))?.puzzle.id,
        const PuzzleId('BBBBB'),
      );
    });

    test('a fresh streak can be resumed offline before the first solve', () async {
      var online = true;
      final container = await _makeContainer(
        _reconnectingClient(() => online, streakIds: ['AAAAA', 'BBBBB', 'CCCCC']),
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      // The active-streak pointer is saved as soon as the streak starts…
      final saved = await container.read(streakStorageProvider(null)).loadActiveStreak();
      expect(saved?.index, 0);

      // …so going offline and reopening the screen resumes at index 0 from the cache.
      online = false;
      container.invalidate(puzzleStreakControllerProvider);
      final resumed = await container.read(puzzleStreakControllerProvider.future);
      expect(resumed.streak.index, 0);
      expect(resumed.puzzle.puzzle.id, const PuzzleId('AAAAA'));
      expect(resumed.nextPuzzle?.puzzle.id, const PuzzleId('BBBBB'));
    });

    test('resumes an active streak offline when puzzles are cached', () async {
      final container = await _makeContainer(_offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      final state = await container.read(puzzleStreakControllerProvider.future);

      expect(state.streak.index, 0);
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'));
      expect(state.nextPuzzle?.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('resuming an active streak offline with an empty cache surfaces an error', () async {
      final container = await _makeContainer(_offlineClient);

      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      expect(await _awaitBuildError(container), isA<Exception>());
    });

    test('a corrupt cached current puzzle self-heals from the network', () async {
      final ids = ['MptxK', '4CZxz'];
      final container = await _makeContainer(_onlineClient(ids));

      // Write a corrupt row for the current puzzle directly into SQLite.
      final db = await container.read(databaseProvider.future);
      await db.insert('puzzle', {
        'puzzleId': 'MptxK',
        'lastModified': DateTime.now().toIso8601String(),
        'data': 'not-json',
      });
      await container.read(streakStorageProvider(null)).saveActiveStreak(_activeStreak(ids));

      _keepAlive(container);
      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(
        (await puzzleStorage.fetch(puzzleId: const PuzzleId('MptxK')))?.puzzle.id,
        const PuzzleId('MptxK'),
      );
    });

    test('starting a brand-new streak offline surfaces an error', () async {
      final container = await _makeContainer(_offlineClient);

      _keepAlive(container);
      expect(await _awaitBuildError(container), isNotNull);
    });

    test('prefetch stores upcoming puzzles in SQLite', () async {
      final ids = ['AAAAA', 'BBBBB', 'CCCCC', 'DDDDD', 'EEEEE'];
      final container = await _makeContainer(_onlineClient(ids));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      for (final id in ['CCCCC', 'DDDDD', 'EEEEE']) {
        expect(
          (await _waitForCached(puzzleStorage, PuzzleId(id)))?.puzzle.id,
          PuzzleId(id),
          reason: 'puzzle $id should have been prefetched',
        );
      }
    });

    test('signed-in prefetch warms the cache with a single /api/puzzle/many request', () async {
      final ids = ['AAAAA', 'BBBBB', 'CCCCC', 'DDDDD', 'EEEEE'];
      final requests = _RequestLog();
      final container = await _makeContainer(
        _countingClient(ids, requests),
        authUser: fakeAuthUser,
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      for (final id in ['CCCCC', 'DDDDD', 'EEEEE']) {
        expect(
          (await _waitForCached(puzzleStorage, PuzzleId(id)))?.puzzle.id,
          PuzzleId(id),
          reason: 'puzzle $id should have been prefetched',
        );
      }

      // The look-ahead window (index 2 onward) is warmed in one batched request,
      // not one round-trip per puzzle.
      expect(requests.manyIds, [
        ['CCCCC', 'DDDDD', 'EEEEE'],
      ]);
      // Only the immediate next puzzle (index 1) is fetched individually.
      expect(requests.singleIds, ['BBBBB']);
    });

    test('anonymous prefetch falls back to per-id fetches', () async {
      // `/api/puzzle/many` requires the `web:mobile` OAuth scope, so an
      // anonymous session must not use it (it would get a 401 for every batch).
      final ids = ['AAAAA', 'BBBBB', 'CCCCC', 'DDDDD', 'EEEEE'];
      final requests = _RequestLog();
      final container = await _makeContainer(_countingClient(ids, requests));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      for (final id in ['CCCCC', 'DDDDD', 'EEEEE']) {
        expect(
          (await _waitForCached(puzzleStorage, PuzzleId(id)))?.puzzle.id,
          PuzzleId(id),
          reason: 'puzzle $id should have been prefetched',
        );
      }

      expect(requests.manyIds, isEmpty);
      expect(requests.singleIds, containsAll(['BBBBB', 'CCCCC', 'DDDDD', 'EEEEE']));
    });

    test('the look-ahead buffer is replenished as the streak progresses', () async {
      // 45 ids: the initial prefetch warms indexes 2-31; advancing consumes the
      // buffer until fewer than 10 warmed puzzles remain, which must trigger a
      // second batched request for the rest (indexes 32-44).
      final ids = [for (var i = 0; i < 45; i++) 'PZ${i.toString().padLeft(3, '0')}'];
      final requests = _RequestLog();
      final container = await _makeContainer(
        _countingClient(ids, requests),
        authUser: fakeAuthUser,
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      // Wait for the initial prefetch to complete before advancing.
      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(await _waitForCached(puzzleStorage, PuzzleId(ids[31])), isNotNull);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      for (var i = 0; i < 22; i++) {
        expect(await notifier.next(), StreakAdvance.advanced);
      }

      for (var i = 0; i < 100 && requests.manyIds.length < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(requests.manyIds, [ids.sublist(2, 32), ids.sublist(32, 45)]);
    });

    test('next() advances offline when the next puzzle is cached', () async {
      final container = await _makeContainer(_offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.advanced);

      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
      expect(state.nextPuzzle, isNull);
    });

    test('next() with an uncached next puzzle offline is a graceful no-op', () async {
      final container = await _makeContainer(_offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      final initial = await container.read(puzzleStreakControllerProvider.future);
      expect(initial.nextPuzzle, isNull);

      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.unavailable);

      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.streak.index, 0);
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'));
    });

    test('a win that cannot advance offline stays on the solved puzzle', () async {
      final container = await _makeContainer(_offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      final initial = await container.read(puzzleStreakControllerProvider.future);
      expect(initial.nextPuzzle, isNull);

      // Offline with no cached successor: next() reports the puzzle as
      // unavailable (so the UI can tell the user) and leaves the streak on the
      // solved puzzle (it resumes automatically on reconnect).
      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.unavailable);

      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.index, 0);
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'));
    });

    test('next() self-heals and resumes automatically once back online', () async {
      var online = false;
      final client = MockClient((request) async {
        if (!online) return http.Response('', 500);
        final path = request.url.path;
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await _makeContainer(client);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      final initial = await container.read(puzzleStreakControllerProvider.future);
      expect(initial.nextPuzzle, isNull);

      online = true;
      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.advanced);

      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('a stuck advance resumes automatically on reconnect', () async {
      var online = false;
      final container = await _makeContainer(_reconnectingClient(() => online));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await _waitForConnectivity(container, isOnline: false);

      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.unavailable);

      // Back online: the controller must advance without any user action.
      online = true;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await _waitForConnectivity(container, isOnline: true);

      for (var i = 0; i < 100; i++) {
        if (container.read(puzzleStreakControllerProvider).value?.streak.index == 1) break;
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('a network-fetched puzzle is kept even when the cache write fails', () async {
      // Online, but every cache write throws. fetchPuzzle must still return the
      // puzzle it fetched from the network rather than swallowing it to null,
      // which would make build() wrongly report the streak as unloadable.
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => _onlineClient(['MptxK', '4CZxz'])),
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) async {
            final db = await ref.watch(databaseProvider.future);
            return _SaveThrowingStorage(db);
          }),
        },
      );

      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'));
      expect(state.nextPuzzle?.puzzle.id, const PuzzleId('4CZxz'));
    });
  });
}

const _basePuzzleJson = '''
{
  "game": {
    "id": "3dwjUYP0",
    "perf": {"key": "rapid", "name": "Rapid"},
    "rated": true,
    "players": [
      {"userId": "suresh", "name": "Suresh (1716)", "color": "white"},
      {"userId": "yulia", "name": "Yulia (1765)", "color": "black"}
    ],
    "pgn": "d4 Nf6 Nf3 e6 c4 d5 cxd5 Bb4+ Nc3 Nxd5 Bd2 c6 a3 Bxc3 Bxc3 Nd7 Ne5 Qc7 e3 O-O Bd3 Nxc3 bxc3 Nxe5 dxe5 Qxc3 a4 b6 Rc1 Qf6 Rxc6 Bb7 Rc4 Rad8 Rd4 Qg5 g3 Rxd4 exd4 Qd5 f3 Rd8 Rf2 g6 Be4 Qd7 Bxb7 Qxb7 Kg2 Qd7 Rd2 e5 dxe5",
    "clock": "10+0"
  },
  "puzzle": {
    "id": "MptxK",
    "rating": 642,
    "plays": 13675,
    "initialPly": 54,
    "solution": ["d7d2", "d1d2", "d8d2"],
    "themes": ["endgame", "crushing", "short"]
  }
}
''';
