import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/features/game/data/game_repository.dart';
import 'package:lichess_mobile/src/features/game/data/game_event.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

const gameIdTest = GameId('5IrD6Gzz');

void main() {
  final mockLogger = MockLogger();
  final mockApiClient = MockApiClient();
  final repo = GameRepository(mockLogger, apiClient: mockApiClient);

  setUpAll(() {
    reset(mockApiClient);
  });

  group('GameRepository.gameStateEvents', () {
    test('can read all supported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode(
                  '{ "type": "gameFull", "id": "$gameIdTest", "initialFen": "startPos", "state": { "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3", "wtime": 7598040, "btime": 8395220, "status": "started" }}'),
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }'),
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6 f1c4", "wtime": 7598140, "btime": 8398220, "status": "started" }'),
            ]),
            200);
      });

      final stream = repo.gameStateEvents(gameIdTest);

      expect(
          stream,
          emitsInOrder([
            predicate((value) => value is GameFullEvent),
            predicate((value) => value is GameStateEvent),
            predicate((value) => value is GameStateEvent),
          ]));
    });

    test('filter out unsupported types of events', () async {
      when(() => mockApiClient.stream(
              Uri.parse('$kLichessHost/api/board/game/stream/$gameIdTest')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
            Stream.fromIterable([
              utf8.encode(
                  '{ "type": "gameState", "moves": "e2e4 c7c5 f2f4 d7d6 g1f3 b8c6", "wtime": 7598140, "btime": 8395220, "status": "started" }'),
              utf8.encode(
                  '{ "type": "chatLine", "username": "testUser", "message": "oops" }'),
            ]),
            200);
      });

      final stream = repo.gameStateEvents(gameIdTest);

      expect(
          stream,
          emitsInOrder([
            predicate((value) => value is GameStateEvent),
          ]));
    });
  });
}
