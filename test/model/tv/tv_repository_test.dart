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
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';

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
    "antichess": {
        "color": "white",
        "gameId": "RofQdyBG",
        "rating": 2222,
        "user": {
            "id": "snezhok777",
            "name": "Snezhok777"
        }
    },
    "atomic": {
        "color": "black",
        "gameId": "3Sd0elkL",
        "rating": 2072,
        "user": {
            "id": "fide-sahand",
            "name": "FIDE-SAHAND"
        }
    },
    "best": {
        "color": "white",
        "gameId": "H4DPx15L",
        "rating": 2954,
        "user": {
            "id": "chessisnotfair",
            "name": "Chessisnotfair",
            "title": "GM"
        }
    },
    "blitz": {
        "color": "white",
        "gameId": "v3pIFdTz",
        "rating": 2615,
        "user": {
            "id": "gemivuk",
            "name": "gemivuk",
            "title": "GM"
        }
    },
    "bot": {
        "color": "white",
        "gameId": "NRfWSRwD",
        "rating": 2731,
        "user": {
            "id": "caissa-test",
            "name": "caissa-test",
            "title": "BOT"
        }
    },
    "bullet": {
        "color": "white",
        "gameId": "H4DPx15L",
        "rating": 2954,
        "user": {
            "id": "chessisnotfair",
            "name": "Chessisnotfair",
            "title": "GM"
        }
    },
    "chess960": {
        "color": "black",
        "gameId": "Itv9tinK",
        "rating": 2259,
        "user": {
            "id": "ti-ga",
            "name": "Ti-Ga",
            "title": "FM"
        }
    },
    "classical": {
        "color": "white",
        "gameId": "s6AArAR4",
        "rating": 2017,
        "user": {
            "id": "aku_sofi-bodo",
            "name": "aku_sofi-bodo"
        }
    },
    "computer": {
        "color": "white",
        "gameId": "6VdUmiKE",
        "rating": 2183,
        "user": {
            "id": "farbod_king",
            "name": "Farbod_king"
        }
    },
    "crazyhouse": {
        "color": "white",
        "gameId": "TdDcjyPz",
        "rating": 2190,
        "user": {
            "id": "ageless_2",
            "name": "Ageless_2"
        }
    },
    "horde": {
        "color": "white",
        "gameId": "WfZ18lIf",
        "rating": 2447,
        "user": {
            "id": "bagera9",
            "name": "bagera9"
        }
    },
    "kingOfTheHill": {
        "color": "black",
        "gameId": "jTpl62fa",
        "rating": 2097,
        "user": {
            "id": "evgeny036",
            "name": "Evgeny036"
        }
    },
    "racingKings": {
        "color": "white",
        "gameId": "3pAqChhF",
        "rating": 1298,
        "user": {
            "id": "oburch11",
            "name": "Oburch11"
        }
    },
    "rapid": {
        "color": "black",
        "gameId": "Z74J2aQ2",
        "rating": 2408,
        "user": {
            "id": "tsukuru",
            "name": "Tsukuru",
            "patron": true
        }
    },
    "threeCheck": {
        "color": "black",
        "gameId": "pKpWRnsH",
        "rating": 1982,
        "user": {
            "id": "vdsukhov",
            "name": "vdsukhov",
            "patron": true
        }
    },
    "ultraBullet": {
        "color": "black",
        "gameId": "TT4BvMOf",
        "rating": 2004,
        "user": {
            "id": "i-play-atomic",
            "name": "i-play-atomic"
        }
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

      // supported channels only
      expect(result.asValue?.value.length, 13);

      expect(
        result.asValue?.value[TvChannel.best]?.user.name,
        'Chessisnotfair',
      );
    });
  });
}
