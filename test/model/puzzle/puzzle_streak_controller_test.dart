import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_provider_scope.dart';
import '../../utils/fake_connectivity.dart';
import '../../view/puzzle/example_data.dart';
import '../auth/fake_auth_storage.dart';
import 'mock_server_responses.dart';

String _puzzleJsonWithId(String id) {
  final map = jsonDecode(mockDailyPuzzleResponse) as Map<String, dynamic>;
  (map['puzzle'] as Map<String, dynamic>)['id'] = id;
  return jsonEncode(map);
}

/// A `/api/streak` response for [ids], with [ids].first embedded.
String _streakJson(List<String> ids) {
  final map = jsonDecode(mockDailyPuzzleResponse) as Map<String, dynamic>;
  (map['puzzle'] as Map<String, dynamic>)['id'] = ids.first;
  map['streak'] = ids.join(' ');
  return jsonEncode(map);
}

/// A `/api/puzzle/many` response with one puzzle per id.
String _manyJson(Iterable<String> ids) {
  return jsonEncode({'puzzles': ids.map((id) => jsonDecode(_puzzleJsonWithId(id))).toList()});
}

/// Puzzle ids requested via `/api/puzzle/many` (one entry per request) and `/api/puzzle/{id}`.
class _RequestLog {
  final manyIds = <List<String>>[];
  final singleIds = <String>[];
}

/// Serves `/api/streak`, `/api/puzzle/many` and `/api/puzzle/{id}` for any id.
MockClient _onlineClient(List<String> streakIds, {_RequestLog? log}) {
  return MockClient((request) async {
    final path = request.url.path;
    if (path == '/api/streak') {
      return http.Response(_streakJson(streakIds), 200);
    }
    if (path == '/api/puzzle/many') {
      final requested = request.url.queryParameters['ids']!.split(',');
      log?.manyIds.add(requested);
      return http.Response(_manyJson(requested), 200);
    }
    if (path.startsWith('/api/puzzle/')) {
      final id = path.split('/').last;
      log?.singleIds.add(id);
      return http.Response(_puzzleJsonWithId(id), 200);
    }
    return http.Response('', 404);
  });
}

/// Throws while `isOnline()` is false, otherwise serves streaks, puzzles and streak-run posts
/// (recorded into [postedRuns]).
MockClient _reconnectingClient(
  bool Function() isOnline, {
  List<String>? streakIds,
  List<int>? postedRuns,
}) {
  return MockClient((request) async {
    if (!isOnline()) {
      throw http.ClientException('offline');
    }
    final path = request.url.path;
    if (request.method == 'POST' && path.startsWith('/api/streak/')) {
      postedRuns?.add(int.parse(path.split('/').last));
      return http.Response('', 200);
    }
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

/// Keeps the autoDispose controller alive, as the streak screen does. Listening triggers `build()`,
/// so call it after populating storage.
ProviderSubscription<AsyncValue<StreakState>> _keepAlive(ProviderContainer container) {
  return container.listen(puzzleStreakControllerProvider, (_, _) {}, onError: (_, _) {});
}

/// Polls until the controller carries an error. Its `.future` never completes on failure, since
/// Riverpod auto-retries a failed provider.
Future<Object?> _awaitBuildError(ProviderContainer container) async {
  for (var i = 0; i < 200; i++) {
    final value = container.read(puzzleStreakControllerProvider);
    if (value.error != null) return value.error;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  return null;
}

/// Polls until the controller carries a run, e.g. after a reconnect reloads a failed one.
Future<StreakState?> _awaitStreak(ProviderContainer container) async {
  for (var i = 0; i < 200; i++) {
    final value = container.read(puzzleStreakControllerProvider);
    if (value case AsyncData(:final value, isLoading: false)) return value;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  return null;
}

/// Polls [storage] until [id] is present, since the prefetch is fire-and-forget.
Future<Puzzle?> _waitForCached(PuzzleStorage storage, PuzzleId id) async {
  for (var i = 0; i < 100; i++) {
    final cached = await storage.fetch(puzzleId: id);
    if (cached != null) return cached;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  return null;
}

Future<void> _waitForConnectivity(ProviderContainer container, {required bool isOnline}) async {
  for (var i = 0; i < 200; i++) {
    if (container.read(connectivityChangesProvider).value?.isOnline == isOnline) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('connectivity did not report isOnline=$isOnline');
}

class _ClearThrowingStreakStorage extends StreakStorage {
  const _ClearThrowingStreakStorage(super.ref, super.userId);

  @override
  Future<void> clearActiveStreak() => Future.error(Exception('simulated disk-write failure'));
}

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

Puzzle _puzzle(String id) => puzzle.copyWith(puzzle: puzzle.puzzle.copyWith(id: PuzzleId(id)));

void main() {
  // the connectivity provider registers an AppLifecycleListener
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PuzzleStreakController local-first fetching', () {
    test('a fresh streak caches its first puzzle, embedded in /api/streak', () async {
      final ids = ['AAAAA', 'BBBBB', 'CCCCC'];
      final container = await lichessClientContainer(_onlineClient(ids));

      _keepAlive(container);
      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.puzzle.puzzle.id, const PuzzleId('AAAAA'));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(
        (await puzzleStorage.fetch(puzzleId: const PuzzleId('AAAAA')))?.puzzle.id,
        const PuzzleId('AAAAA'),
      );
    });

    test('a fresh streak can be resumed offline before the first solve', () async {
      var online = true;
      final container = await lichessClientContainer(
        _reconnectingClient(() => online, streakIds: ['AAAAA', 'BBBBB', 'CCCCC']),
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final saved = await container.read(streakStorageProvider(null)).loadActiveStreak();
      expect(saved?.index, 0);

      // going offline and reopening the screen resumes from the cache
      online = false;
      container.invalidate(puzzleStreakControllerProvider);
      final resumed = await container.read(puzzleStreakControllerProvider.future);
      expect(resumed.streak.index, 0);
      expect(resumed.puzzle.puzzle.id, const PuzzleId('AAAAA'));
    });

    test('resumes an active streak offline when puzzles are cached', () async {
      final container = await lichessClientContainer(offlineClient);

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
    });

    test('resuming an active streak offline with an empty cache surfaces an error', () async {
      final container = await lichessClientContainer(offlineClient);

      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      expect(await _awaitBuildError(container), isA<Exception>());
    });

    test('a corrupt cached current puzzle self-heals from the network', () async {
      final ids = ['MptxK', '4CZxz'];
      final container = await lichessClientContainer(_onlineClient(ids));

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
      final container = await lichessClientContainer(offlineClient);

      _keepAlive(container);
      expect(await _awaitBuildError(container), isNotNull);
    });

    test('prefetch warms the cache with a single /api/puzzle/many request', () async {
      final ids = ['AAAAA', 'BBBBB', 'CCCCC', 'DDDDD', 'EEEEE'];
      final requests = _RequestLog();
      final container = await lichessClientContainer(
        _onlineClient(ids, log: requests),
        authUser: fakeAuthUser,
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      for (final id in ['BBBBB', 'CCCCC', 'DDDDD', 'EEEEE']) {
        expect(
          (await _waitForCached(puzzleStorage, PuzzleId(id)))?.puzzle.id,
          PuzzleId(id),
          reason: 'puzzle $id should have been prefetched',
        );
      }

      // everything past the embedded first puzzle is warmed in one request
      expect(requests.manyIds, [
        ['BBBBB', 'CCCCC', 'DDDDD', 'EEEEE'],
      ]);
      expect(requests.singleIds, isEmpty);
    });

    test('the look-ahead buffer is replenished as the streak progresses', () async {
      // the initial prefetch warms indexes 1-30, the second request the 30 after those
      final ids = [for (var i = 0; i < 70; i++) 'PZ${i.toString().padLeft(3, '0')}'];
      final requests = _RequestLog();
      final container = await lichessClientContainer(
        _onlineClient(ids, log: requests),
        authUser: fakeAuthUser,
      );

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(await _waitForCached(puzzleStorage, PuzzleId(ids[30])), isNotNull);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      for (var i = 0; i < 22; i++) {
        expect(await notifier.next(), StreakAdvance.advanced);
      }

      for (var i = 0; i < 100 && requests.manyIds.length < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(requests.manyIds, [
        ids.sublist(1, 31),
        ids.sublist(31, 61),
      ], reason: 'a refill must start where the cached range ends, not overlap it');
    });

    /// Advances [n] times against a `/api/puzzle/many` that always answers [status], and returns
    /// how many times it was called. Single puzzle fetches always succeed, as on lichess, where
    /// `/api/puzzle/{id}` is not rate limited.
    Future<int> countRefillsWhenManyFails(int status, {int advances = 10}) async {
      final ids = [for (var i = 0; i < 40; i++) 'RZ${i.toString().padLeft(3, '0')}'];
      var manyRequests = 0;
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path == '/api/streak') {
          return http.Response(_streakJson(ids), 200);
        }
        if (path == '/api/puzzle/many') {
          manyRequests++;
          return http.Response('', status, request: request);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      for (var i = 0; i < advances; i++) {
        expect(await notifier.next(), StreakAdvance.advanced);
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return manyRequests;
    }

    test('a look-ahead refill that fails transiently backs off, then retries', () async {
      // 10 advances at a 5-advance back-off
      final requests = await countRefillsWhenManyFails(503);
      expect(
        requests,
        lessThanOrEqualTo(3),
        reason: 'the failed refill must back off, not fire once per solved puzzle',
      );
      expect(
        requests,
        greaterThan(1),
        reason: 'the back-off must expire on its own, without needing a reconnect',
      );
    });

    test('a rate-limited look-ahead refill stands down for the rest of the run', () async {
      // `/api/puzzle/many` shares a per-IP hourly budget with `/api/puzzle/batch/`, so a 429 will
      // not clear within a run. Retrying only spends requests the rest of the app needs.
      expect(await countRefillsWhenManyFails(429), 1);
    });

    test('a refused look-ahead refill is not retried on reconnect', () async {
      var online = true;
      var manyRequests = 0;
      final ids = [for (var i = 0; i < 40; i++) 'RC${i.toString().padLeft(3, '0')}'];
      final client = MockClient((request) async {
        if (!online) throw http.ClientException('offline');
        final path = request.url.path;
        if (path == '/api/streak') {
          return http.Response(_streakJson(ids), 200);
        }
        if (path == '/api/puzzle/many') {
          manyRequests++;
          return http.Response('', 429, request: request);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await _waitForConnectivity(container, isOnline: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(manyRequests, 1);

      online = false;
      FakeConnectivity.controller.add([ConnectivityResult.none]);
      await _waitForConnectivity(container, isOnline: false);
      online = true;
      // connectivity changes are throttled
      await Future<void>.delayed(kConnectivityThrottleDelay);
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await _waitForConnectivity(container, isOnline: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(manyRequests, 1, reason: 'the hourly budget does not clear on reconnect');
    });

    test('the run plays on normally once the look-ahead is rate limited', () async {
      final ids = [for (var i = 0; i < 40; i++) 'RL${i.toString().padLeft(3, '0')}'];
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path == '/api/streak') {
          return http.Response(_streakJson(ids), 200);
        }
        if (path == '/api/puzzle/many') {
          return http.Response('', 429, request: request);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      for (var i = 1; i < 10; i++) {
        expect(await notifier.next(), StreakAdvance.advanced);
        expect(
          container.read(puzzleStreakControllerProvider).requireValue.puzzle.puzzle.id.value,
          ids[i],
        );
      }
    });

    test('an id dropped from a /api/puzzle/many response is fetched on its own', () async {
      final ids = [for (var i = 0; i < 45; i++) 'HZ${i.toString().padLeft(3, '0')}'];
      final dropped = ids[10];
      final requests = _RequestLog();
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path == '/api/streak') {
          return http.Response(_streakJson(ids), 200);
        }
        if (path == '/api/puzzle/many') {
          final requested = request.url.queryParameters['ids']!.split(',');
          requests.manyIds.add(requested);
          return http.Response(_manyJson(requested.where((id) => id != dropped)), 200);
        }
        if (path.startsWith('/api/puzzle/')) {
          final id = path.split('/').last;
          requests.singleIds.add(id);
          return http.Response(_puzzleJsonWithId(id), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(await _waitForCached(puzzleStorage, PuzzleId(ids[30])), isNotNull);
      expect(await puzzleStorage.fetch(puzzleId: PuzzleId(dropped)), isNull);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);

      // the run reaches the dropped puzzle, which is fetched on its own
      for (var i = 0; i < 10; i++) {
        expect(await notifier.next(), StreakAdvance.advanced);
      }
      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.index, 10);
      expect(state.puzzle.puzzle.id, PuzzleId(dropped));
      expect(requests.singleIds, contains(dropped));

      // the hole does not cost a second look-ahead request: the window counts as warmed
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(requests.manyIds, hasLength(1));
    });

    test('overlapping look-ahead refills issue a single /api/puzzle/many request', () async {
      final ids = [for (var i = 0; i < 40; i++) 'QZ${i.toString().padLeft(3, '0')}'];
      final requests = _RequestLog();
      final gate = Completer<void>();
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path == '/api/streak') {
          return http.Response(_streakJson(ids), 200);
        }
        if (path == '/api/puzzle/many') {
          final requested = request.url.queryParameters['ids']!.split(',');
          requests.manyIds.add(requested);
          await gate.future;
          return http.Response(_manyJson(requested), 200);
        }
        if (path.startsWith('/api/puzzle/')) {
          final id = path.split('/').last;
          requests.singleIds.add(id);
          return http.Response(_puzzleJsonWithId(id), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      for (var i = 0; i < 200 && requests.manyIds.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(requests.manyIds, hasLength(1));

      // advancing while the first refill is still in flight
      expect(
        await container.read(puzzleStreakControllerProvider.notifier).next(),
        StreakAdvance.advanced,
      );
      expect(requests.manyIds, hasLength(1));

      gate.complete();
      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      expect(await _waitForCached(puzzleStorage, PuzzleId(ids[5])), isNotNull);
      expect(requests.manyIds, hasLength(1));
    });

    test(
      'signing out mid-refill still warms the look-ahead of the streak that replaces it',
      () async {
        // signing out rebuilds the controller on the same notifier instance
        final oldIds = [for (var i = 0; i < 40; i++) 'AA${i.toString().padLeft(3, '0')}'];
        final newIds = [for (var i = 0; i < 40; i++) 'BB${i.toString().padLeft(3, '0')}'];
        final requests = _RequestLog();
        final gate = Completer<void>();
        var streaksServed = 0;
        final client = MockClient((request) async {
          final path = request.url.path;
          if (path == '/api/streak') {
            return http.Response(_streakJson(streaksServed++ == 0 ? oldIds : newIds), 200);
          }
          if (path == '/api/puzzle/many') {
            final requested = request.url.queryParameters['ids']!.split(',');
            requests.manyIds.add(requested);
            await gate.future;
            return http.Response(_manyJson(requested), 200);
          }
          if (path.startsWith('/api/puzzle/')) {
            final id = path.split('/').last;
            requests.singleIds.add(id);
            return http.Response(_puzzleJsonWithId(id), 200);
          }
          // token revocation on sign-out
          return http.Response('', 200);
        });

        final container = await lichessClientContainer(client, authUser: fakeAuthUser);
        _keepAlive(container);
        await container.read(puzzleStreakControllerProvider.future);

        for (var i = 0; i < 200 && requests.manyIds.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        expect(requests.manyIds, hasLength(1));
        expect(requests.manyIds.single.first, startsWith('AA'));

        await container.read(authControllerProvider.notifier).signOut();
        await container.read(puzzleStreakControllerProvider.future);

        for (var i = 0; i < 200 && requests.manyIds.length < 2; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        expect(
          requests.manyIds,
          hasLength(2),
          reason: 'the anonymous streak should have asked for its own look-ahead window',
        );
        expect(requests.manyIds[1].first, startsWith('BB'));

        gate.complete();
        final puzzleStorage = await container.read(puzzleStorageProvider.future);
        expect(await _waitForCached(puzzleStorage, PuzzleId(newIds[5])), isNotNull);
      },
    );

    test('two concurrent advances move the streak only once', () async {
      var online = false;
      final client = MockClient((request) async {
        if (!online) return http.Response('', 500);
        final path = request.url.path;
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz', 'Bmn3z']));

      _keepAlive(container);
      // the next puzzle is not cached, so the advance has to await a fetch
      await container.read(puzzleStreakControllerProvider.future);

      online = true;
      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      final results = await Future.wait([notifier.next(), notifier.next()]);

      // whichever fetch lands first advances, the other stands down
      expect(results, unorderedEquals([StreakAdvance.advanced, StreakAdvance.aborted]));

      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('next() advances offline when the next puzzle is cached', () async {
      final container = await lichessClientContainer(offlineClient);

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
    });

    test('a win that cannot advance offline stays on the solved puzzle', () async {
      final container = await lichessClientContainer(offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

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

      final container = await lichessClientContainer(client);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      online = true;
      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.advanced);

      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('a stuck advance resumes automatically on reconnect', () async {
      var online = false;
      final container = await lichessClientContainer(_reconnectingClient(() => online));

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

    test('a stuck advance that fails again on reconnect can be retried by hand', () async {
      var online = false;
      var failuresLeft = 0;
      final container = await lichessClientContainer(
        MockClient((request) async {
          if (!online) throw http.ClientException('offline');
          // the connectivity probe sends HEAD requests: only puzzle fetches fail
          if (failuresLeft > 0 && request.url.path.startsWith('/api/puzzle/')) {
            failuresLeft--;
            return http.Response('', 500);
          }
          return http.Response(_puzzleJsonWithId(request.url.path.split('/').last), 200);
        }),
      );

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await _waitForConnectivity(container, isOnline: false);

      final notifier = container.read(puzzleStreakControllerProvider.notifier);
      expect(await notifier.next(), StreakAdvance.unavailable);

      // the first request after the reconnect still fails
      failuresLeft = 1;
      online = true;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await _waitForConnectivity(container, isOnline: true);
      for (var i = 0; i < 20 && failuresLeft > 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(failuresLeft, 0, reason: 'the reconnect must try to advance');
      final stuck = container.read(puzzleStreakControllerProvider).requireValue;
      expect(stuck.streak.advancePending, isTrue, reason: 'the solve is still waiting');

      expect(await notifier.next(), StreakAdvance.advanced);
      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.index, 1);
      expect(state.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('a solve stranded offline is not replayed after leaving the screen', () async {
      var online = false;
      final container = await lichessClientContainer(_reconnectingClient(() => online));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      final open = _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await _waitForConnectivity(container, isOnline: false);

      expect(
        await container.read(puzzleStreakControllerProvider.notifier).next(),
        StreakAdvance.unavailable,
      );

      final stranded = await container.read(streakStorageProvider(null)).loadActiveStreak();
      expect(stranded?.index, 0);
      expect(stranded?.advancePending, isTrue);
      expect(stranded?.score, 1, reason: 'the stranded solve counts');
      expect(
        await container.read(savedStreakScoreProvider.future),
        1,
        reason: 'the puzzle tab badge shows the same score',
      );

      // leave the screen (autoDispose runs on a later tick)
      open.close();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.exists(puzzleStreakControllerProvider), isFalse);

      online = true;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);

      // reopening completes the pending advance
      _keepAlive(container);
      final resumed = await container.read(puzzleStreakControllerProvider.future);
      expect(resumed.streak.index, 1, reason: 'the stranded solve must still count');
      expect(resumed.puzzle.puzzle.id, const PuzzleId('4CZxz'));
      expect(resumed.streak.advancePending, isFalse);

      final saved = await container.read(streakStorageProvider(null)).loadActiveStreak();
      expect(saved?.index, 1, reason: 'the completed advance must be persisted, not just shown');
    });

    test('a solve stranded offline is not replayed when resumed offline', () async {
      var online = false;
      final container = await lichessClientContainer(_reconnectingClient(() => online));

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']).copyWith(advancePending: true));

      _keepAlive(container);
      expect(await _awaitBuildError(container), isA<Exception>());
      await _waitForConnectivity(container, isOnline: false);

      online = true;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);

      final resumed = await _awaitStreak(container);
      expect(resumed?.streak.index, 1, reason: 'the stranded solve must still count');
      expect(resumed?.puzzle.puzzle.id, const PuzzleId('4CZxz'));
    });

    test('gameOver() offline does not throw', () async {
      final container = await lichessClientContainer(offlineClient);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(null))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await container.read(puzzleStreakControllerProvider.notifier).gameOver();

      final state = await container.read(puzzleStreakControllerProvider.future);
      expect(state.streak.finished, isTrue);
    });

    test('savePendingScore keeps the best pending run', () async {
      final container = await lichessClientContainer(offlineClient, authUser: fakeAuthUser);
      final storage = container.read(streakStorageProvider(fakeAuthUser.user.id));

      await storage.savePendingScore(3);
      await storage.savePendingScore(8);
      await storage.savePendingScore(5);
      expect(await storage.loadPendingScore(), 8);

      await storage.clearPendingScoreIfAtMost(5);
      expect(await storage.loadPendingScore(), 8);

      await storage.clearPendingScoreIfAtMost(8);
      expect(await storage.loadPendingScore(), isNull);
    });

    test('gameOver() offline saves the streak score to post later', () async {
      final container = await lichessClientContainer(offlineClient, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(userId))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz'], index: 1));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await container.read(puzzleStreakControllerProvider.notifier).gameOver();

      expect(await container.read(streakStorageProvider(userId)).loadPendingScore(), 1);
    });

    test('gameOver() queues the score before clearing the run', () async {
      final container = await makeContainer(
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => offlineClient),
          ),
          streakStorageProvider: streakStorageProvider.overrideWith(
            (ref, userId) => _ClearThrowingStreakStorage(ref, userId),
          ),
        },
      );
      final userId = fakeAuthUser.user.id;

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(userId))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz'], index: 1));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await expectLater(
        container.read(puzzleStreakControllerProvider.notifier).gameOver(),
        throwsException,
      );

      expect(
        await container.read(streakStorageProvider(userId)).loadPendingScore(),
        1,
        reason: 'a run must not be lost to whatever happens after it is queued',
      );
    });

    test(
      'a streak whose current puzzle the server refuses is ended and its score posted',
      () async {
        final postedRuns = <int>[];
        final client = MockClient((request) async {
          final path = request.url.path;
          if (request.method == 'POST' && path.startsWith('/api/streak/')) {
            postedRuns.add(int.parse(path.split('/').last));
            return http.Response('', 200);
          }
          if (path == '/api/streak') {
            return http.Response(_streakJson(['NEWa1', 'NEWb2']), 200);
          }
          if (path == '/api/puzzle/many') {
            return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
          }
          if (path == '/api/puzzle/GONE1') {
            return http.Response('', 404);
          }
          if (path.startsWith('/api/puzzle/')) {
            return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
          }
          return http.Response('', 404);
        });
        final container = await lichessClientContainer(client, authUser: fakeAuthUser);
        final userId = fakeAuthUser.user.id;
        await container
            .read(streakStorageProvider(userId))
            .saveActiveStreak(_activeStreak(['MptxK', 'GONE1', '4CZxz'], index: 1));

        _keepAlive(container);
        final state = await container.read(puzzleStreakControllerProvider.future);

        expect(state.puzzle.puzzle.id, const PuzzleId('NEWa1'), reason: 'a new run starts instead');
        expect(state.streak.index, 0);
        expect(postedRuns, [1], reason: 'the puzzles solved before the hole count');

        final storage = container.read(streakStorageProvider(userId));
        expect((await storage.loadActiveStreak())?.streak.first, const PuzzleId('NEWa1'));
        expect(await storage.loadPendingScore(), isNull);
      },
    );

    test('gameOver() does not queue a streak score the server rejects outright', () async {
      final client = MockClient((request) async {
        final path = request.url.path;
        // lila answers BadRequest for a score it will never record, e.g. one out of range.
        if (request.method == 'POST' && path.startsWith('/api/streak/')) {
          return http.Response('', 400);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('MptxK'));
      await puzzleStorage.save(puzzle: _puzzle('4CZxz'));
      await container
          .read(streakStorageProvider(userId))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz'], index: 1));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await container.read(puzzleStreakControllerProvider.notifier).gameOver();

      expect(
        await container.read(streakStorageProvider(userId)).loadPendingScore(),
        isNull,
        reason: 'a rejected run must not be retried on every reconnect',
      );
    });

    test('a next puzzle the server refuses ends the run with the solve counted', () async {
      final postedRuns = <int>[];
      final client = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'POST' && path.startsWith('/api/streak/')) {
          postedRuns.add(int.parse(path.split('/').last));
          return http.Response('', 200);
        }
        if (path == '/api/puzzle/GONE1') {
          return http.Response('', 404);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });
      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;
      await container
          .read(streakStorageProvider(userId))
          .saveActiveStreak(_activeStreak(['MptxK', 'GONE1', '4CZxz']));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      final result = await container.read(puzzleStreakControllerProvider.notifier).next();
      expect(result, StreakAdvance.ended);

      final state = container.read(puzzleStreakControllerProvider).requireValue;
      expect(state.streak.finished, isTrue);
      expect(state.streak.score, 1, reason: 'the solve counts');
      expect(state.puzzle.puzzle.id, const PuzzleId('MptxK'), reason: 'the solved puzzle stays');
      expect(postedRuns, [1]);

      final storage = container.read(streakStorageProvider(userId));
      expect(await storage.loadActiveStreak(), isNull);
      expect(await storage.loadPendingScore(), isNull);
    });

    test('a pending streak score the server rejects outright is dropped', () async {
      var posts = 0;
      final client = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'POST' && path.startsWith('/api/streak/')) {
          posts++;
          return http.Response('', 400);
        }
        if (path == '/api/streak') {
          return http.Response(_streakJson(['AAAAA', 'BBBBB', 'CCCCC']), 200);
        }
        if (path == '/api/puzzle/many') {
          return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      await container.read(streakStorageProvider(userId)).savePendingScore(7);

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      for (var i = 0; i < 100 && posts == 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(posts, 1);
      expect(await container.read(streakStorageProvider(userId)).loadPendingScore(), isNull);
    });

    test('a pending streak score survives a server error, to be posted later', () async {
      var posts = 0;
      final client = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'POST' && path.startsWith('/api/streak/')) {
          posts++;
          return http.Response('', 503);
        }
        if (path == '/api/streak') {
          return http.Response(_streakJson(['AAAAA', 'BBBBB', 'CCCCC']), 200);
        }
        if (path == '/api/puzzle/many') {
          return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      await container.read(streakStorageProvider(userId)).savePendingScore(7);

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      for (var i = 0; i < 100 && posts == 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(await container.read(streakStorageProvider(userId)).loadPendingScore(), 7);
    });

    test('a pending streak score is posted on the next build once back online', () async {
      final postedRuns = <int>[];
      final client = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'POST' && path.startsWith('/api/streak/')) {
          postedRuns.add(int.parse(path.split('/').last));
          return http.Response('', 200);
        }
        if (path == '/api/streak') {
          return http.Response(_streakJson(['AAAAA', 'BBBBB', 'CCCCC']), 200);
        }
        if (path == '/api/puzzle/many') {
          return http.Response(_manyJson(request.url.queryParameters['ids']!.split(',')), 200);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      await container.read(streakStorageProvider(userId)).savePendingScore(7);

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);

      for (var i = 0; i < 100 && postedRuns.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(postedRuns, [7]);
      expect(await container.read(streakStorageProvider(userId)).loadPendingScore(), isNull);
    });

    test('gameOver() online clears a now-redundant lower pending score', () async {
      final client = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'POST' && path == '/api/streak/2') {
          return http.Response('', 200);
        }
        if (request.method == 'POST') {
          return http.Response('', 500);
        }
        if (path.startsWith('/api/puzzle/')) {
          return http.Response(_puzzleJsonWithId(path.split('/').last), 200);
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client, authUser: fakeAuthUser);
      final userId = fakeAuthUser.user.id;

      await container.read(streakStorageProvider(userId)).savePendingScore(1);

      final puzzleStorage = await container.read(puzzleStorageProvider.future);
      await puzzleStorage.save(puzzle: _puzzle('kcN3a'));
      await container
          .read(streakStorageProvider(userId))
          .saveActiveStreak(_activeStreak(['MptxK', '4CZxz', 'kcN3a'], index: 2));

      _keepAlive(container);
      await container.read(puzzleStreakControllerProvider.future);
      await container.read(puzzleStreakControllerProvider.notifier).gameOver();

      expect(await container.read(streakStorageProvider(userId)).loadPendingScore(), isNull);
    });

    test('a network-fetched puzzle is kept even when the cache write fails', () async {
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
    });
  });
}
