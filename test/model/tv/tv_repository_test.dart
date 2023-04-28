import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_event.dart';

class MockAuthClient extends Mock implements AuthClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockLogger = MockLogger();
  final mockAuthClient = MockAuthClient();
  final repo = TvRepository(mockLogger, apiClient: mockAuthClient);

  setUpAll(() {
    reset(mockAuthClient);
  });

  group('TvRepository.tvFeed', () {
    test('can read all supported types of events', () async {
      when(() => mockAuthClient.stream(Uri.parse('$kLichessHost/api/tv/feed')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
          Stream.fromIterable([
            utf8.encode(
              '{ "t": "featured", "d": { "id": "qVSOPtMc", "orientation": "black", "fen": "rnbqk1r1/ppp1ppbp/8/N2p2p1/8/1PQPP3/P1P2PPn/R1B1K1NR", "players": [{ "color": "white", "user": { "name": "lizen9", "id": "lizen9", "title": "GM" }, "rating": 2531 }, { "color": "black", "user": { "name": "lizen29", "id": "lizen29", "title": "WGM" }, "rating": 2594 }]}}',
            ),
            utf8.encode(
              '{ "t": "fen", "d": { "lm": "g1f3", "fen": "rnbqk1r1/ppp1ppbp/8/N2p2p1/8/1PQPP3/P1P2PPn/R1B1K1NR", "wc": 123124, "bc": 103235 }}',
            ),
            utf8.encode(
              '{ "t": "fen", "d": { "lm": "g1f3", "fen": "rnbqk1r1/ppp1ppbp/8/N2p2p1/8/1QPP3/P1P2PPn/R1B1K1NR", "wc": 123120, "bc": 103230 }}',
            ),
          ]),
          200,
        );
      });

      final stream = repo.tvFeed();

      expect(
        stream,
        emitsInOrder([
          predicate((value) => value is TvFeaturedEvent),
          predicate((value) => value is TvFenEvent),
          predicate((value) => value is TvFenEvent),
        ]),
      );
    });

    test('filter out unsupported types of events', () async {
      when(() => mockAuthClient.stream(Uri.parse('$kLichessHost/api/tv/feed')))
          .thenAnswer((_) async {
        return http.StreamedResponse(
          Stream.fromIterable([
            utf8.encode(
              '{ "t": "fen", "d": { "lm": "g1f3", "fen": "rnbqk1r1/ppp1ppbp/8/N2p2p1/8/1QPP3/P1P2PPn/R1B1K1NR", "wc": 123120, "bc": 103230 }}',
            ),
            utf8.encode('{ "t": "oops", "d": {}}'),
          ]),
          200,
        );
      });

      final stream = repo.tvFeed();

      expect(
        stream,
        emitsInOrder([
          predicate((value) => value is TvFenEvent),
        ]),
      );
    });
  });
}
