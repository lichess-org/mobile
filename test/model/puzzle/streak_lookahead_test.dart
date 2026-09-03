import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_lookahead.dart';

import '../../test_container.dart';
import '../../view/puzzle/example_data.dart';
import 'mock_server_responses.dart';

String _puzzleJsonWithId(String id) {
  final map = jsonDecode(mockDailyPuzzleResponse) as Map<String, dynamic>;
  (map['puzzle'] as Map<String, dynamic>)['id'] = id;
  return jsonEncode(map);
}

/// A `/api/puzzle/many` response with one puzzle per id.
String _manyJson(Iterable<String> ids) {
  return jsonEncode({'puzzles': ids.map((id) => jsonDecode(_puzzleJsonWithId(id))).toList()});
}

void main() {
  final run = IList([for (var i = 0; i < 70; i++) PuzzleId('LA${i.toString().padLeft(3, '0')}')]);

  /// Serves `/api/puzzle/many` with [status], recording each request's ids into [requests].
  MockClient manyClient(List<List<String>> requests, {int status = 200}) {
    return MockClient((request) async {
      if (request.url.path != '/api/puzzle/many') return http.Response('', 404);
      final ids = request.url.queryParameters['ids']!.split(',');
      requests.add(ids);
      return http.Response(status == 200 ? _manyJson(ids) : '', status, request: request);
    });
  }

  Future<StreakLookahead> makeLookahead(MockClient client) async {
    final container = await lichessClientContainer(client);
    return StreakLookahead(
      run,
      storage: await container.read(puzzleStorageProvider.future),
      repository: container.read(puzzleRepositoryProvider),
    );
  }

  group('StreakLookahead', () {
    test('caches a window past the current puzzle, then the next one once it runs low', () async {
      final requests = <List<String>>[];
      final lookahead = await makeLookahead(manyClient(requests));

      await lookahead.refill(0);
      expect(requests, [run.sublist(1, 31).map((id) => id.value)]);

      // still enough cached ahead
      await lookahead.refill(20);
      expect(requests, hasLength(1));

      await lookahead.refill(21);
      expect(requests, hasLength(2), reason: 'fewer than the margin cached past index 21');
      expect(requests[1], run.sublist(31, 61).map((id) => id.value));
      expect(await lookahead.storage.fetch(puzzleId: run[60]), isNotNull);
    });

    test('skips the puzzles already stored, and stops at the end of the run', () async {
      final requests = <List<String>>[];
      final lookahead = await makeLookahead(manyClient(requests));
      await lookahead.storage.save(
        puzzle: puzzle.copyWith(puzzle: puzzle.puzzle.copyWith(id: run[62])),
      );

      await lookahead.refill(60);
      expect(requests, [
        [run[61].value, ...run.sublist(63).map((id) => id.value)],
      ]);

      await lookahead.refill(69);
      expect(requests, hasLength(1));
    });

    test('a failed refill backs off for a few advances, then retries', () async {
      final requests = <List<String>>[];
      final lookahead = await makeLookahead(manyClient(requests, status: 503));

      for (var i = 0; i < 5; i++) {
        await lookahead.refill(i);
      }
      expect(requests, hasLength(1), reason: 'not once per solved puzzle');
      await lookahead.refill(5);
      expect(requests, hasLength(2));
    });

    test('a refused refill stands down for the rest of the run', () async {
      final requests = <List<String>>[];
      final lookahead = await makeLookahead(manyClient(requests, status: 429));

      for (var i = 0; i < 69; i++) {
        await lookahead.refill(i);
      }
      expect(requests, hasLength(1));
    });
  });
}
