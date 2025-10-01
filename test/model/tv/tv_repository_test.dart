import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('TvRepository.channels', () {
    test('correctly parse JSON', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tv/channels') {
          return mockResponse(tvChannelsResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(tvRepositoryProvider);

      final result = await repo.channels();

      expect(result, isA<TvChannels>());

      // supported channels only
      expect(result.length, 13);

      expect(result[TvChannel.best]?.user.name, 'Chessisnotfair');
    });
  });
}

const tvChannelsResponse = '''
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
            "patron": true,
            "patronColor": 1
        }
    },
    "threeCheck": {
        "color": "black",
        "gameId": "pKpWRnsH",
        "rating": 1982,
        "user": {
            "id": "vdsukhov",
            "name": "vdsukhov",
            "patron": true,
            "patronColor": 1
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
