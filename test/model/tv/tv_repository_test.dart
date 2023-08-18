import 'dart:convert';
import 'package:async/async.dart';
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

  group('TvRepository.channels', () {
    test('correctly parse JSON', () async {
      const response = '''
{
  "Bot": {
    "user": {
      "id": "leelachess",
      "name": "LeelaChess",
      "title": "BOT"
    },
    "rating": 2660,
    "gameId": "Zznv9MIl",
    "color": "black"
  },
  "Blitz": {
    "user": {
      "id": "lekkerkortook",
      "name": "LekkerKortOok"
    },
    "rating": 2603,
    "gameId": "hTJ4v7Mp",
    "color": "black"
  },
  "Racing Kings": {
    "user": {
      "id": "chesslo21",
      "name": "chesslo21"
    },
    "rating": 2123,
    "gameId": "lgCDl5Of",
    "color": "white"
  },
  "UltraBullet": {
    "user": {
      "id": "farmville",
      "name": "Farmville"
    },
    "rating": 2338,
    "gameId": "NEY6OQ32",
    "color": "white"
  },
  "Bullet": {
    "user": {
      "id": "nurmibrah",
      "name": "nurmiBrah"
    },
    "rating": 2499,
    "gameId": "5LgyE516",
    "color": "black"
  },
  "Classical": {
    "user": {
      "id": "holden_m_j_thomas",
      "name": "Holden_M_J_Thomas"
    },
    "rating": 1806,
    "gameId": "k3oLby6N",
    "color": "white"
  },
  "Three-check": {
    "user": {
      "id": "pepellou",
      "name": "pepellou",
      "patron": true
    },
    "rating": 1978,
    "gameId": "Og5RCvmu",
    "color": "black"
  },
  "Antichess": {
    "user": {
      "id": "maria-bakkar",
      "name": "maria-bakkar"
    },
    "rating": 2103,
    "gameId": "toCr41yx",
    "color": "black"
  },
  "Computer": {
    "user": {
      "id": "oh_my_goat_im_so_bat",
      "name": "oh_my_goat_Im_so_bat"
    },
    "rating": 2314,
    "gameId": "TkI4qZxu",
    "color": "black"
  },
  "Horde": {
    "user": {
      "id": "habitualchess",
      "name": "HabitualChess"
    },
    "rating": 1803,
    "gameId": "oMofN63H",
    "color": "white"
  },
  "Rapid": {
    "user": {
      "id": "denpayd",
      "name": "DenpaYD"
    },
    "rating": 2289,
    "gameId": "IcWOl8ee"
  },
  "Atomic": {
    "user": {
      "id": "meetyourdemise",
      "name": "MeetYourDemise"
    },
    "rating": 2210,
    "gameId": "tvMxtCMN",
    "color": "white"
  },
  "Crazyhouse": {
    "user": {
      "id": "mathace",
      "name": "mathace"
    },
    "rating": 2397,
    "gameId": "i3gTZlUb",
    "color": "black"
  },
  "Chess960": {
    "user": {
      "id": "voja_7",
      "name": "voja_7"
    },
    "rating": 1782,
    "gameId": "lrXLcedu",
    "color": "white"
  },
  "King of the Hill": {
    "user": {
      "id": "nadime",
      "name": "Nadime"
    },
    "rating": 1500,
    "gameId": "DsQn8aEV",
    "color": "white"
  },
  "Top Rated": {
    "user": {
      "id": "lekkerkortook",
      "name": "LekkerKortOok"
    },
    "rating": 2603,
    "gameId": "hTJ4v7Mp",
    "color": "black"
  }
}
''';

      when(
        () => mockAuthClient.get(
          Uri.parse(
            '$kLichessHost/api/tv/channels',
          ),
        ),
      ).thenAnswer((_) async => Result.value(http.Response(response, 200)));

      final result = await repo.channels();

      expect(result.isValue, true);
    });
  });
}
